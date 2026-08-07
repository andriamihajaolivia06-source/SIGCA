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

            // Récupérer le cf_code
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

            // Si la recherche est plus longue que 5 caractères, prendre les 5 derniers
            if (strlen($search) > 5) {
                $search = substr($search, -5);
            }

            // Étape 1: Trouver le(s) BDEF par les 5 derniers caractères
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

            // Récupérer tous les bdef trouvés
            $bdefList = array_column($bdefResults, 'bdef');
            $placeholders = implode(',', array_fill(0, count($bdefList), '?'));

            // Étape 2: Récupérer TOUS les engagements (numDef) liés à ces BDEF
            $queryEngagements = "
                SELECT 
                    id_eng,
                    bdef,
                    \"numDef\",
                    objet,
                    montant,
                    \"dateEngagement\",
                    \"etatEng\",
                    \"tiersNom\",
                    exercice,
                    ministere
                FROM engagement
                WHERE cf_code = ?
                  AND exercice = ?
                  AND bdef IN ({$placeholders})
                ORDER BY \"dateEngagement\" DESC NULLS LAST
            ";

            $params = array_merge([$cfCode, $annee], $bdefList);
            $results = $db->query($queryEngagements, $params)->getResultArray();

            // Grouper les résultats par BDEF
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
                    id_eng,
                    bdef,
                    \"numDef\",
                    numdefdeg,
                    objet,
                    montant,
                    \"dateEngagement\",
                    \"etatEng\",
                    \"tiersNom\",
                    exercice,
                    ministere,
                    CASE 
                        WHEN numdefdeg IS NOT NULL AND numdefdeg != '' THEN 'DEG'
                        ELSE 'DEF'
                    END as type_document
                FROM engagement
                WHERE cf_code = ?
                  AND exercice = ?
                  AND (
                      (\"numDef\" IS NOT NULL AND \"numDef\" != '')
                      OR 
                      (numdefdeg IS NOT NULL AND numdefdeg != '')
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

    
}