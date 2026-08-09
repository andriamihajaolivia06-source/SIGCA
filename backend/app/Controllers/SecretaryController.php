<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class SecretaryController extends ResourceController
{
    protected $format = 'json';

    public function delegations()
    {
        $immatricule = $this->request->getGet('immatricule');
        $annee = $this->request->getGet('annee');

        if (!$immatricule || !$annee) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Immatricule et année requis'
            ]);
        }

        $db = db_connect();

        $user = $db->query("
            SELECT *
            FROM user_multiple
            WHERE TRIM(im_utilisateur) = ?
              AND TRIM(exercice) = ?
              AND TRIM(etat) = 'actif'
            LIMIT 1
        ", [$immatricule, $annee])->getRowArray();

        if (!$user) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Utilisateur non trouvé'
            ]);
        }

        $idDelegations = array_map('trim', explode(',', $user['cf_code']));
        $idDelegations = array_filter($idDelegations);
        $idDelegations = array_map('intval', $idDelegations);

        $delegations = [];
        if (!empty($idDelegations)) {
            $placeholders = implode(',', array_fill(0, count($idDelegations), '?'));
            $delegations = $db->query("
                SELECT id_delegation, cf_code, lib_delegation, abrev
                FROM delegation
                WHERE id_delegation IN ({$placeholders})
                ORDER BY lib_delegation ASC
            ", $idDelegations)->getResultArray();
        }

        return $this->response->setJSON([
            'success' => true,
            'delegations' => $delegations,
            'user' => [
                'nom' => trim($user['nom_utilisateur']),
                'prenom' => trim($user['prenom_utilisateur']),
                'immatricule' => trim($user['im_utilisateur']),
                'role' => trim($user['role']),
                'annee' => trim($user['exercice']),
                'id_delegations' => $idDelegations
            ]
        ]);
    }

    public function searchBdef()
    {
        $idDelegation = $this->request->getGet('id_delegation');
        $search = $this->request->getGet('search');
        $annee = $this->request->getGet('annee');

        if (!$idDelegation || !$annee) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Paramètres manquants'
            ]);
        }

        if (empty($search)) {
            return $this->response->setJSON([
                'success' => true,
                'results' => [],
                'count' => 0,
                'type' => 'bdef'
            ]);
        }

        try {
            $db = db_connect();

            $delegation = $db->table('delegation')
                ->select('cf_code')
                ->where('id_delegation', $idDelegation)
                ->get()
                ->getRowArray();

            if (!$delegation) {
                return $this->response->setJSON([
                    'success' => false,
                    'message' => 'Délégation non trouvée'
                ]);
            }

            $cfCode = trim($delegation['cf_code']);
            $search = trim($search);

            if (strlen($search) > 5) {
                $search = substr($search, -5);
            }

            $queryBdef = "
                SELECT DISTINCT bdef
                FROM engagement
                WHERE cf_code = ?
                  AND exercice = ?
                  AND bdef IS NOT NULL
                  AND bdef != ''
                  AND SUBSTRING(bdef FROM LENGTH(bdef) - 4) = ?
            ";

            $bdefResults = $db->query($queryBdef, [$cfCode, $annee, $search])->getResultArray();

            if (empty($bdefResults)) {
                return $this->response->setJSON([
                    'success' => true,
                    'results' => [],
                    'count' => 0,
                    'type' => 'bdef'
                ]);
            }

            $bdefList = array_column($bdefResults, 'bdef');
            $placeholders = implode(',', array_fill(0, count($bdefList), '?'));

            $queryEngagements = "
                SELECT 
                    e.id_eng,
                    e.bdef,
                    e.\"numDef\",
                    e.objet,
                    e.montant,
                    e.\"dateEngagement\",
                    e.\"etatEng\",
                    e.\"tiersNom\",
                    e.exercice,
                    e.ministere
                FROM engagement e
                WHERE e.cf_code = ?
                AND e.exercice = ?
                AND e.bdef IN ({$placeholders})
                AND NOT EXISTS (
                    SELECT 1 FROM secretaire_aller1 sa
                    WHERE sa.\"numDef\" = e.\"numDef\"
                )
                ORDER BY e.\"dateEngagement\" DESC NULLS LAST
            ";

            $params = array_merge([$cfCode, $annee], $bdefList);
            $results = $db->query($queryEngagements, $params)->getResultArray();

            $groupedResults = [];
            foreach ($results as $row) {
                $bdefKey = trim($row['bdef']);
                if (!isset($groupedResults[$bdefKey])) {
                    $groupedResults[$bdefKey] = [
                        'bdef' => $row['bdef'],
                        'engagements' => []
                    ];
                }
                $groupedResults[$bdefKey]['engagements'][] = [
                    'id' => $row['id_eng'],
                    'numDef' => $row['numDef'] ?? 'Sans numDef',
                    'objet' => $row['objet'] ?? 'Sans objet',
                    'montant' => $row['montant'] ?? 0,
                    'date' => $row['dateEngagement'] ?? null,
                    'etat' => $row['etatEng'] ?? 'ATTENTE',
                    'tiers' => $row['tiersNom'] ?? '',
                    'ministere' => $row['ministere'] ?? ''
                ];
            }

            $formattedResults = [];
            foreach ($groupedResults as $bdef => $data) {
                $formattedResults[] = [
                    'bdef' => $bdef,
                    'engagements' => $data['engagements'],
                    'total_engagements' => count($data['engagements'])
                ];
            }

            return $this->response->setJSON([
                'success' => true,
                'results' => $formattedResults,
                'count' => count($formattedResults),
                'total_engagements' => count($results),
                'type' => 'bdef'
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    public function searchDef()
    {
        $idDelegation = $this->request->getGet('id_delegation');
        $search = $this->request->getGet('search');
        $annee = $this->request->getGet('annee');

        if (!$idDelegation || !$annee) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Paramètres manquants'
            ]);
        }

        if (empty($search)) {
            return $this->response->setJSON([
                'success' => true,
                'results' => [],
                'count' => 0,
                'type' => 'def'
            ]);
        }

        try {
            $db = db_connect();

            $delegation = $db->table('delegation')
                ->select('cf_code')
                ->where('id_delegation', $idDelegation)
                ->get()
                ->getRowArray();

            if (!$delegation) {
                return $this->response->setJSON([
                    'success' => false,
                    'message' => 'Délégation non trouvée'
                ]);
            }

            $cfCode = trim($delegation['cf_code']);

            $query = "
                SELECT 
                    e.id_eng,
                    e.bdef,
                    e.\"numDef\",
                    e.numdefdeg,
                    e.objet,
                    e.montant,
                    e.\"dateEngagement\",
                    e.\"etatEng\",
                    e.\"tiersNom\",
                    e.exercice,
                    e.ministere,
                    CASE 
                        WHEN e.numdefdeg IS NOT NULL AND e.numdefdeg != '' THEN 'DEG'
                        ELSE 'DEF'
                    END as type_document
                FROM engagement e
                WHERE e.cf_code = ?
                AND e.exercice = ?
                AND (
                    (e.\"numDef\" IS NOT NULL AND e.\"numDef\" != '')
                    OR 
                    (e.numdefdeg IS NOT NULL AND e.numdefdeg != '')
                )
                AND NOT EXISTS (
                    SELECT 1 FROM secretaire_aller1 sa
                    WHERE sa.\"numDef\" = e.\"numDef\"
                )
            ";

            $params = [$cfCode, $annee];

            if (!empty($search)) {
                $query .= " AND (
                    \"numDef\" LIKE ? 
                    OR numdefdeg LIKE ? 
                    OR objet LIKE ?
                )";
                $params[] = "%{$search}%";
                $params[] = "%{$search}%";
                $params[] = "%{$search}%";
            }

            $query .= " ORDER BY \"dateEngagement\" DESC NULLS LAST LIMIT 50";

            $results = $db->query($query, $params)->getResultArray();

            $formattedResults = array_map(function($row) {
                return [
                    'id' => $row['id_eng'] ?? null,
                    'bdef' => $row['bdef'] ?? '',
                    'numDef' => $row['numDef'] ?? '',
                    'numdefdeg' => $row['numdefdeg'] ?? '',
                    'objet' => $row['objet'] ?? 'Sans objet',
                    'montant' => $row['montant'] ?? 0,
                    'date' => $row['dateEngagement'] ?? null,
                    'etat' => $row['etatEng'] ?? 'ATTENTE',
                    'tiers' => $row['tiersNom'] ?? '',
                    'exercice' => $row['exercice'] ?? '',
                    'type_document' => $row['type_document'] ?? 'DEF',
                    'ministere' => $row['ministere'] ?? ''
                ];
            }, $results);

            return $this->response->setJSON([
                'success' => true,
                'results' => $formattedResults,
                'count' => count($formattedResults),
                'type' => 'def'
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Valider les engagements sélectionnés
     * POST /api/secretary/validate
     */
    public function validateEngagements()
    {
        $data = $this->request->getJSON(true);

        $immatricule = $data['immatricule'] ?? null;
        $annee = $data['annee'] ?? null;
        $email = $data['email'] ?? null;
        $selectedEngagements = $data['selectedEngagements'] ?? [];

        if (empty($selectedEngagements)) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Aucun engagement sélectionné'
            ]);
        }

        if (!$immatricule || !$annee) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Immatricule et année requis'
            ]);
        }

        try {
            $db = db_connect();

            $user = $db->query("
                SELECT *
                FROM user_multiple
                WHERE TRIM(im_utilisateur) = ?
                  AND TRIM(exercice) = ?
                  AND TRIM(etat) = 'actif'
                LIMIT 1
            ", [$immatricule, $annee])->getRowArray();

            if (!$user) {
                return $this->response->setJSON([
                    'success' => false,
                    'message' => 'Utilisateur non trouvé'
                ]);
            }

            $loginReception = trim($user['im_utilisateur']);
            $dateReception = date('Y-m-d H:i:s');

            // 1. Insérer l'email dans tbl_mail si fourni
            if (!empty($email)) {
                foreach ($selectedEngagements as $engagement) {
                    $existing = $db->table('tbl_mail')
                        ->where('numDef', $engagement['numDef'] ?? '')
                        ->where('adresse_mail', $email)
                        ->get()
                        ->getRowArray();

                    if (!$existing) {
                        $db->table('tbl_mail')->insert([
                            'numDef' => $engagement['numDef'] ?? '',
                            'adresse_mail' => $email,
                            'etat_email' => 0
                        ]);
                    }
                }
            }

            // 2. Insérer les engagements dans secretaire_aller1
            foreach ($selectedEngagements as $engagement) {
                $numDef = $engagement['numDef'] ?? '';

                $last6 = substr($numDef, -6);
                $refCFGenerated = 'refCF' . $annee . $last6;

                $existing = $db->table('secretaire_aller1')
                    ->where('numDef', $numDef)
                    ->get()
                    ->getRowArray();

                if (!$existing) {
                    $db->table('secretaire_aller1')->insert([
                        'id_eng' => $engagement['id'] ?? 0,
                        'numDef' => $numDef,
                        'refCF' => $refCFGenerated,
                        'soumission' => 1,
                        'loginReception1' => $loginReception,
                        'dateReception1' => $dateReception,
                        'etatSecVerif' => 'En attente',
                        'loginCloture' => '',
                        'dateCloture' => null,
                        'etatVerif' => 0,
                        'type' => 'eng',
                        'loginReceptionSec' => '',
                        'dateReceptionSec' => null,
                        'loginClotureSec' => '',
                        'dateClotureSec' => null,
                        'etatSecSigfp' => '',
                        'etatSigfp2' => 0,
                        'nomservice' => '',
                        'dateReceptionService' => null
                    ]);
                }
            }

            return $this->response->setJSON([
                'success' => true,
                'message' => 'Validation effectuée avec succès',
                'total' => count($selectedEngagements),
                'email_sent' => !empty($email)
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Récupérer les engagements validés pour l'envoi vers vérificateur
     * GET /api/secretary/validated-engagements
     */
    public function getValidatedEngagements()
    {
        $immatricule = $this->request->getGet('immatricule');
        $annee = $this->request->getGet('annee');

        if (!$immatricule || !$annee) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Immatricule et année requis'
            ]);
        }

        try {
            $db = db_connect();

            // Récupérer l'utilisateur pour vérifier son login
            $user = $db->query("
                SELECT *
                FROM user_multiple
                WHERE TRIM(im_utilisateur) = ?
                  AND TRIM(exercice) = ?
                  AND TRIM(etat) = 'actif'
                LIMIT 1
            ", [$immatricule, $annee])->getRowArray();

            if (!$user) {
                return $this->response->setJSON([
                    'success' => false,
                    'message' => 'Utilisateur non trouvé'
                ]);
            }

            $loginReception = trim($user['im_utilisateur']);

            // Requête avec guillemets doubles pour PostgreSQL (case sensitive)
            $query = "
                SELECT 
                    sa.\"id_secretaire\",
                    sa.\"id_eng\",
                    sa.\"numDef\",
                    sa.\"refCF\",
                    sa.\"soumission\",
                    sa.\"loginReception1\",
                    sa.\"dateReception1\",
                    sa.\"etatSecVerif\",
                    sa.\"etatVerif\",
                    sa.\"type\",
                    sa.\"loginCloture\",
                    sa.\"dateCloture\",
                    e.\"bdef\",
                    e.\"objet\",
                    e.\"montant\",
                    e.\"exercice\"
                FROM \"secretaire_aller1\" sa
                LEFT JOIN \"engagement\" e ON sa.\"numDef\" = e.\"numDef\"
                WHERE sa.\"loginReception1\" = ?
                  AND sa.\"etatSecVerif\" = 'En attente'
                  AND sa.\"etatVerif\" = 0
                ORDER BY sa.\"dateReception1\" DESC
            ";

            $results = $db->query($query, [$loginReception])->getResultArray();

            return $this->response->setJSON([
                'success' => true,
                'results' => $results,
                'count' => count($results),
                'loginReception' => $loginReception
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Clôturer les engagements vers le vérificateur
     * POST /api/secretary/close-engagements
     */
    public function closeEngagements()
    {
        $data = $this->request->getJSON(true);

        $immatricule = $data['immatricule'] ?? null;
        $annee = $data['annee'] ?? null;
        $selectedEngagements = $data['selectedEngagements'] ?? [];

        if (empty($selectedEngagements)) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Aucun engagement sélectionné'
            ]);
        }

        if (!$immatricule || !$annee) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Immatricule et année requis'
            ]);
        }

        try {
            $db = db_connect();

            $clotureCount = 0;
            $dateCloture = date('Y-m-d H:i:s');

            foreach ($selectedEngagements as $engagement) {
                $idSecretaire = $engagement['id_secretaire'] ?? null;
                $numDef = $engagement['numDef'] ?? '';

                if (!$idSecretaire && !$numDef) {
                    continue;
                }

                $updateData = [
                    'etatSecVerif' => 'Cloturer',
                    'etatVerif' => 1,
                    'loginCloture' => $immatricule,
                    'dateCloture' => $dateCloture
                ];

                if ($idSecretaire) {
                    $db->table('secretaire_aller1')
                        ->where('id_secretaire', $idSecretaire)
                        ->update($updateData);
                } else if ($numDef) {
                    $db->table('secretaire_aller1')
                        ->where('numDef', $numDef)
                        ->update($updateData);
                }
                
                $clotureCount++;
            }

            return $this->response->setJSON([
                'success' => true,
                'message' => 'Clôture effectuée avec succès',
                'total' => $clotureCount
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

        public function getClosedEngagements()
    {
        $immatricule = $this->request->getGet('immatricule');
        $annee = $this->request->getGet('annee');

        if (!$immatricule || !$annee) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Immatricule et année requis'
            ]);
        }

        try {
            $db = db_connect();

            // Récupérer l'utilisateur pour vérifier son login
            $user = $db->query("
                SELECT *
                FROM user_multiple
                WHERE TRIM(im_utilisateur) = ?
                  AND TRIM(exercice) = ?
                  AND TRIM(etat) = 'actif'
                LIMIT 1
            ", [$immatricule, $annee])->getRowArray();

            if (!$user) {
                return $this->response->setJSON([
                    'success' => false,
                    'message' => 'Utilisateur non trouvé'
                ]);
            }

            $loginReception = trim($user['im_utilisateur']);

            // Requête pour récupérer les engagements clôturés
            $query = "
                SELECT 
                    sa.\"id_secretaire\",
                    sa.\"id_eng\",
                    sa.\"numDef\",
                    sa.\"refCF\",
                    sa.\"soumission\",
                    sa.\"loginReception1\",
                    sa.\"dateReception1\",
                    sa.\"etatSecVerif\",
                    sa.\"etatVerif\",
                    sa.\"type\",
                    sa.\"loginCloture\",
                    sa.\"dateCloture\",
                    e.\"bdef\",
                    e.\"objet\",
                    e.\"montant\",
                    e.\"exercice\"
                FROM \"secretaire_aller1\" sa
                LEFT JOIN \"engagement\" e ON sa.\"numDef\" = e.\"numDef\"
                WHERE sa.\"loginReception1\" = ?
                  AND sa.\"etatSecVerif\" = 'Cloturer'
                  AND sa.\"etatVerif\" = 1
                ORDER BY sa.\"dateCloture\" DESC
            ";

            $results = $db->query($query, [$loginReception])->getResultArray();

            return $this->response->setJSON([
                'success' => true,
                'results' => $results,
                'count' => count($results),
                'loginReception' => $loginReception
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }
}