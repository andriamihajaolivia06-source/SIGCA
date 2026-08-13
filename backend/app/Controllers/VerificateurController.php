<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class VerificateurController extends ResourceController
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

    public function searchClosed()
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
                    sa.\"id_secretaire\",
                    sa.\"numDef\",
                    sa.\"refCF\",
                    sa.\"loginReception1\",
                    sa.\"dateReception1\",
                    sa.\"etatSecVerif\",
                    sa.\"loginCloture\",
                    sa.\"dateCloture\",
                    e.\"bdef\",
                    e.\"objet\",
                    e.\"montant\",
                    e.\"exercice\"
                FROM \"secretaire_aller1\" sa
                LEFT JOIN \"engagement\" e ON sa.\"numDef\" = e.\"numDef\"
                WHERE e.\"cf_code\" = ?
                  AND e.\"exercice\" = ?
                  AND sa.\"etatSecVerif\" = 'Cloturer'
                  AND NOT EXISTS (
                      SELECT 1 FROM \"verif_aller1\" v
                      WHERE v.\"numDef\" = sa.\"numDef\"
                  )
            ";

            $params = [$cfCode, $annee];

            if (!empty($search) && $search !== '%') {
                $query .= " AND (
                    sa.\"numDef\" LIKE ? 
                    OR e.\"bdef\" LIKE ? 
                    OR sa.\"refCF\" LIKE ? 
                    OR e.\"objet\" LIKE ?
                )";
                $params[] = "%{$search}%";
                $params[] = "%{$search}%";
                $params[] = "%{$search}%";
                $params[] = "%{$search}%";
            }

            $query .= " ORDER BY sa.\"dateCloture\" DESC";

            $results = $db->query($query, $params)->getResultArray();

            return $this->response->setJSON([
                'success' => true,
                'results' => $results,
                'count' => count($results),
                'cf_code' => $cfCode
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Réceptionner les engagements sélectionnés
     * POST /api/verificateur/reception
     */
    public function reception()
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

            $insertedCount = 0;
            $dateReception = date('Y-m-d H:i:s');

            foreach ($selectedEngagements as $engagement) {
                $idSecretaire = $engagement['id_secretaire'] ?? null;
                $numDef = $engagement['numDef'] ?? '';

                if (!$idSecretaire || !$numDef) {
                    continue;
                }

                // Vérifier si déjà réceptionné
                $existing = $db->table('verif_aller1')
                    ->where('numDef', $numDef)
                    ->get()
                    ->getRowArray();

                if (!$existing) {
                    $db->table('verif_aller1')->insert([
                        'id_secretaire'   => $idSecretaire,
                        'numDef'          => $numDef,
                        'loginReception'  => $immatricule,
                        'dateReception'   => $dateReception,
                        'forme'           => '',
                        'fond'            => '',
                        'proposition'     => '',
                        'observations'    => '',
                        'loginCloture'    => '',
                        'dateCloture'     => null,
                        'etatVerifDel'    => 'Noncloturer',
                        'etatDel'         => 0,
                        'loginReception2' => '',
                        'dateReception2'  => null,
                        'loginCloture2'   => '',
                        'dateCloture2'    => null,
                        'decision'        => '',
                        'etatVerifSec2'   => '',
                        'etatSec2'        => 0,
                        'etatVerifSig'    => '',
                        'etatSigfp'       => 0,
                        'etat'            => 0
                    ]);
                    $insertedCount++;
                }
            }

            return $this->response->setJSON([
                'success' => true,
                'message' => 'Réception effectuée avec succès',
                'total' => $insertedCount
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Récupérer les engagements réceptionnés (Noncloturer)
     * GET /api/verificateur/received-engagements
     */
    public function getReceivedEngagements()
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

            $query = "
                SELECT 
                    v.\"id_verif\",
                    v.\"id_secretaire\",
                    v.\"numDef\",
                    v.\"loginReception\",
                    v.\"dateReception\",
                    v.\"etatVerifDel\",
                    sa.\"refCF\",
                    sa.\"loginReception1\",
                    sa.\"dateReception1\",
                    sa.\"etatSecVerif\",
                    e.\"bdef\",
                    e.\"objet\",
                    e.\"montant\",
                    e.\"exercice\"
                FROM \"verif_aller1\" v
                LEFT JOIN \"secretaire_aller1\" sa ON v.\"id_secretaire\" = sa.\"id_secretaire\"
                LEFT JOIN \"engagement\" e ON v.\"numDef\" = e.\"numDef\"
                WHERE v.\"loginReception\" = ?
                  AND v.\"etatVerifDel\" = 'Noncloturer'
                ORDER BY v.\"dateReception\" DESC
            ";

            $results = $db->query($query, [$immatricule])->getResultArray();

            return $this->response->setJSON([
                'success' => true,
                'results' => $results,
                'count' => count($results)
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Récupérer les détails d'un engagement (pièces justificatives)
     */
    public function getEngagementDetails()
    {
        $numDef = $this->request->getGet('numDef');

        if (!$numDef) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Numéro DEF requis'
            ]);
        }

        try {
            $db = db_connect();

            $engagement = $db->query("
                SELECT \"compte\" 
                FROM \"engagement\" 
                WHERE \"numDef\" = ?
            ", [$numDef])->getRowArray();

            if (!$engagement) {
                return $this->response->setJSON([
                    'success' => true,
                    'pieces' => [],
                    'count' => 0
                ]);
            }

            $compte = $engagement['compte'];

            $pcopList = $db->query("
                SELECT \"id_pcop\", \"compte\", \"libelle_compte\"
                FROM \"pcop\" 
                WHERE \"compte\" = ?
            ", [$compte])->getResultArray();

            if (empty($pcopList)) {
                return $this->response->setJSON([
                    'success' => true,
                    'pieces' => [],
                    'count' => 0
                ]);
            }

            $pcopIds = array_column($pcopList, 'id_pcop');

            $placeholders = implode(',', array_fill(0, count($pcopIds), '?'));
            $pieces = $db->query("
                SELECT \"id_piece\", \"pj\", \"id_pcop\"
                FROM \"piece\" 
                WHERE \"id_pcop\" IN ({$placeholders})
                ORDER BY \"id_piece\"
            ", $pcopIds)->getResultArray();

            if (empty($pieces)) {
                return $this->response->setJSON([
                    'success' => true,
                    'pieces' => [],
                    'count' => 0
                ]);
            }

            $pieces = array_map(function($p) {
                return [
                    'id_piece' => $p['id_piece'],
                    'pj' => $p['pj'] ?? 'Pièce',
                    'checked' => false
                ];
            }, $pieces);

            return $this->response->setJSON([
                'success' => true,
                'pieces' => $pieces,
                'count' => count($pieces),
                'compte' => $compte
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Récupérer les motifs
     */
    public function getMotifs()
    {
        try {
            $db = db_connect();
            
            $motifs = $db->table('motif')
                ->orderBy('id_motif', 'ASC')
                ->get()
                ->getResultArray();

            return $this->response->setJSON([
                'success' => true,
                'motifs' => $motifs
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Enregistrer la vérification et clôturer
     */
    public function saveVerification()
    {
        $data = $this->request->getJSON(true);

        $idVerif = $data['id_verif'] ?? null;
        $idSecretaire = $data['id_secretaire'] ?? null;
        $numDef = $data['numDef'] ?? null;
        $forme = $data['forme'] ?? [];
        $fond = $data['fond'] ?? [];
        $proposition = $data['proposition'] ?? [];
        $loginVerificateur = $data['loginVerificateur'] ?? '';

        if (!$idVerif || !$idSecretaire || !$numDef) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Données manquantes'
            ]);
        }

        try {
            $db = db_connect();

            // 1. Mettre à jour verif_aller1
            $propositionType = '';
            if ($proposition['visa'] ?? 0) {
                $propositionType = 'visa';
            } elseif ($proposition['rejet'] ?? 0) {
                $propositionType = 'rejet';
            } elseif ($proposition['faitretour'] ?? 0) {
                $propositionType = 'faitretour';
            }

            $observationsText = mb_substr($proposition['texte'] ?? '', 0, 200);

            $db->table('verif_aller1')
                ->where('id_verif', $idVerif)
                ->update([
                    'forme'           => $forme['status'] ?? '',
                    'fond'            => $fond['status'] ?? '',
                    'proposition'     => $propositionType,
                    'observations'    => $observationsText,
                    'loginCloture'    => $loginVerificateur,
                    'dateCloture'     => date('Y-m-d H:i:s'),
                    'etatVerifDel'    => 'Cloturer',
                    'etatDel'         => 1,
                    'etat'            => 1
                ]);

            // 2. Enregistrer les motifs sélectionnés dans temp_motif
            $motifIds = $fond['motif_ids'] ?? (isset($fond['motif_id']) ? [$fond['motif_id']] : []);
            foreach ($motifIds as $motifId) {
                $db->table('temp_motif')->insert([
                    'id_motif' => $motifId,
                    'numDef'   => $numDef
                ]);
            }

            // 3. Insérer les pièces cochées dans tbl_verifcloture
            $pieces = $forme['pieces'] ?? [];
            foreach ($pieces as $piece) {
                if ($piece['checked'] ?? false) {
                    // Récupérer les informations de la pièce depuis la table piece
                    $pieceInfo = $db->table('piece')
                        ->select('pj, id_pcop')
                        ->where('id_piece', $piece['id_piece'])
                        ->get()
                        ->getRowArray();

                    // Vérifier si la pièce existe déjà pour cet engagement
                    $existing = $db->table('tbl_verifcloture')
                        ->where('engverifcloture', $numDef)
                        ->where('id_piece', $piece['id_piece'])
                        ->get()
                        ->getRowArray();

                    if (!$existing) {
                        $db->table('tbl_verifcloture')->insert([
                            'engverifcloture' => $numDef,
                            'id_piece' => $piece['id_piece'],
                            'piecejustificative' => $pieceInfo['pj'] ?? '',
                            'id_pcop' => $pieceInfo['id_pcop'] ?? 0
                        ]);
                    }
                }
            }

            // 4. Mettre à jour secretaire_aller1
            $db->table('secretaire_aller1')
                ->where('id_secretaire', $idSecretaire)
                ->update([
                    'etatSecVerif' => 'Verifie',
                    'etatVerif' => 2
                ]);

            return $this->response->setJSON([
                'success' => true,
                'message' => 'Vérification enregistrée avec succès'
            ]);

        } catch (\Throwable $e) {
            log_message('error', 'saveVerification: ' . $e->getMessage());
            return $this->response->setJSON([
                'success' => false,
                'message' => $e->getMessage()
            ]);
        }
    }

        public function getDelegateDecisions()
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

            // Récupérer le login du vérificateur
            $user = $db->query("
                SELECT im_utilisateur, cf_code FROM user_multiple
                WHERE TRIM(im_utilisateur) = ? AND TRIM(exercice) = ?
                LIMIT 1
            ", [$immatricule, $annee])->getRowArray();

            if (!$user) {
                return $this->response->setJSON([
                    'success' => false,
                    'message' => 'Utilisateur non trouvé'
                ]);
            }

            $loginVerificateur = trim($user['im_utilisateur']);

            // Récupérer les décisions du délégué pour les engagements que le vérificateur a vérifiés
            // etatVerif2 = 0 : non lu, etatVerif2 = 1 : lu
            $query = "
                SELECT 
                    d.\"id_del\",
                    d.\"numDef\",
                    d.\"loginReception\",
                    d.\"dateReception\",
                    d.\"loginClotureDel\",
                    d.\"dateClotureDel\",
                    d.\"decisionforme\",
                    d.\"decisionfond\",
                    d.\"decisionfinale\",
                    d.\"decisionObs\",
                    d.\"etatDelVerif\",
                    d.\"etatVerif2\",
                    d.\"etat\",
                    e.\"bdef\",
                    e.\"objet\",
                    e.\"montant\",
                    e.\"exercice\",
                    sa.\"refCF\",
                    sa.\"loginReception1\",
                    sa.\"dateReception1\"
                FROM \"del_aller1\" d
                LEFT JOIN \"secretaire_aller1\" sa ON d.\"numDef\" = sa.\"numDef\"
                LEFT JOIN \"engagement\" e ON d.\"numDef\" = e.\"numDef\"
                LEFT JOIN \"verif_aller1\" v ON d.\"numDef\" = v.\"numDef\"
                WHERE v.\"loginReception\" = ?
                  AND e.\"exercice\" = ?
                  AND d.\"etatDelVerif\" = 'Cloturer'
                ORDER BY d.\"dateClotureDel\" DESC
            ";

            $results = $db->query($query, [$loginVerificateur, $annee])->getResultArray();

            // Compter les non lus (etatVerif2 = 0)
            $unreadCount = 0;
            foreach ($results as $row) {
                if ($row['etatVerif2'] == 0) {
                    $unreadCount++;
                }
            }

            return $this->response->setJSON([
                'success' => true,
                'notifications' => $results,
                'unread_count' => $unreadCount,
                'total' => count($results),
                'login_verificateur' => $loginVerificateur
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    public function markDecisionRead()
    {
        $data = $this->request->getJSON(true);
        $idDel = $data['id_del'] ?? null;

        if (!$idDel) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'ID de la décision requis'
            ]);
        }

        try {
            $db = db_connect();

            $db->table('del_aller1')
                ->where('id_del', $idDel)
                ->update(['etatVerif2' => 1]);

            return $this->response->setJSON([
                'success' => true,
                'message' => 'Notification marquée comme lue'
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    

/**
 * Récupérer les infos nécessaires à la génération du motif de la décision
 * en croisant verif_aller1 (forme/fond du vérificateur) et del_aller1
 * (décision finale/observation du délégué) sur numDef.
 * GET /api/verificateur/decision-motif-details
 */
public function getDecisionMotifDetails()
{
    $numDef = $this->request->getGet('numDef');

    if (!$numDef) {
        return $this->response->setJSON([
            'success' => false,
            'message' => 'Numéro DEF requis'
        ]);
    }

    try {
        $db = db_connect();

        // 1. Evaluation forme/fond faite par le vérificateur (verif_aller1)
        $verif = $db->table('verif_aller1')
            ->select('forme, fond, observations')
            ->where('numDef', $numDef)
            ->orderBy('id_verif', 'DESC')
            ->get()
            ->getRowArray();

        // 2. Décision du délégué (del_aller1) matchée sur le même numDef
        $del = $db->table('del_aller1')
            ->select('decisionfinale, decisionObs')
            ->where('numDef', $numDef)
            ->orderBy('id_del', 'DESC')
            ->get()
            ->getRowArray();

        $forme = trim($verif['forme'] ?? '');
        $fond = trim($verif['fond'] ?? '');

        // 3. Pièces justificatives NON cochées :
        // engagement.compte -> pcop.compte -> piece.id_pcop, moins ce qui a été
        // enregistré comme coché dans tbl_verifcloture pour ce numDef.
        $piecesNonCochees = [];

        $engagement = $db->table('engagement')
            ->select('compte')
            ->where('numDef', $numDef)
            ->get()
            ->getRowArray();

        if ($engagement && !empty($engagement['compte'])) {
            $pcopList = $db->table('pcop')
                ->select('id_pcop')
                ->where('compte', $engagement['compte'])
                ->get()
                ->getResultArray();

            if (!empty($pcopList)) {
                $pcopIds = array_column($pcopList, 'id_pcop');
                $placeholders = implode(',', array_fill(0, count($pcopIds), '?'));

                $allPieces = $db->query("
                    SELECT \"id_piece\", \"pj\"
                    FROM \"piece\"
                    WHERE \"id_pcop\" IN ({$placeholders})
                ", $pcopIds)->getResultArray();

                $checkedRows = $db->table('tbl_verifcloture')
                    ->select('id_piece')
                    ->where('engverifcloture', $numDef)
                    ->get()
                    ->getResultArray();
                $checkedIds = array_map('intval', array_column($checkedRows, 'id_piece'));

                foreach ($allPieces as $p) {
                    if (!in_array((int) $p['id_piece'], $checkedIds, true)) {
                        $piecesNonCochees[] = trim($p['pj']);
                    }
                }
            }
        }

        // 4. Motifs choisis pour justifier un fond anormal (temp_motif + motif)
        $motifRows = $db->query("
            SELECT m.\"lib_motif\"
            FROM \"temp_motif\" t
            LEFT JOIN \"motif\" m ON t.\"id_motif\" = m.\"id_motif\"
            WHERE t.\"numDef\" = ?
        ", [$numDef])->getResultArray();

        $motifsChoisis = array_values(array_filter(array_map(function ($m) {
            return trim($m['lib_motif'] ?? '');
        }, $motifRows)));

        return $this->response->setJSON([
            'success' => true,
            'numDef' => $numDef,
            'forme' => $forme,
            'fond' => $fond,
            'piecesNonCochees' => $piecesNonCochees,
            'motifsChoisis' => $motifsChoisis,
            'decisionfinale' => $del['decisionfinale'] ?? '',
            'decisionObs' => $del['decisionObs'] ?? ''
        ]);

    } catch (\Exception $e) {
        return $this->response->setJSON([
            'success' => false,
            'error' => $e->getMessage()
        ]);
    }
}

public function getEngagementFullDetails()
{
    $numDef = $this->request->getGet('numDef');

    if (!$numDef) {
        return $this->response->setJSON([
            'success' => false,
            'message' => 'Numéro DEF requis'
        ]);
    }

    try {
        $db = db_connect();

        $engagement = $db->query("
            SELECT 
                e.\"id_eng\",
                e.\"dateBdef\",
                e.\"bdef\",
                e.\"numDef\",
                e.\"numdefdeg\",
                e.\"ministere\",
                e.\"mission\",
                e.\"programme\",
                e.\"soa\",
                e.\"ordsec\",
                e.\"cf_code\",
                e.\"convention\",
                e.\"financement\",
                e.\"refMarche\",
                e.\"tiersCode\",
                e.\"tiersNom\",
                e.\"compte\",
                e.\"objet\",
                e.\"categorie\",
                e.\"dateEngagement\",
                e.\"region\",
                e.\"montant\",
                e.\"creditModifie\",
                e.\"loiFinance\",
                e.\"type_engagement\",
                e.\"procedure\",
                e.\"etatEng\",
                e.\"exercice\"
            FROM \"engagement\" e
            WHERE e.\"numDef\" = ?
            LIMIT 1
        ", [$numDef])->getRowArray();

        if (!$engagement) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Engagement non trouvé'
            ]);
        }

        return $this->response->setJSON([
            'success' => true,
            'engagement' => $engagement
        ]);

    } catch (\Exception $e) {
        return $this->response->setJSON([
            'success' => false,
            'error' => $e->getMessage()
        ]);
    }
}



public function getDelegateClosedEngagements()
{
    $immatricule = $this->request->getGet('immatricule');
    $annee = $this->request->getGet('annee');
    $search = $this->request->getGet('search') ?? '%';

    if (!$immatricule || !$annee) {
        return $this->response->setJSON([
            'success' => false,
            'message' => 'Immatricule et année requis'
        ]);
    }

    try {
        $db = db_connect();

        $user = $db->query("
            SELECT cf_code FROM user_multiple
            WHERE TRIM(im_utilisateur) = ? AND TRIM(exercice) = ?
              AND TRIM(etat) = 'actif'
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

        if (empty($idDelegations)) {
            return $this->response->setJSON([
                'success' => true,
                'results' => [],
                'count' => 0
            ]);
        }

        $placeholders = implode(',', array_fill(0, count($idDelegations), '?'));
        $cfCodes = $db->query("
            SELECT cf_code FROM delegation
            WHERE id_delegation IN ({$placeholders})
        ", $idDelegations)->getResultArray();

        $cfCodes = array_map(fn($row) => trim($row['cf_code']), $cfCodes);

        if (empty($cfCodes)) {
            return $this->response->setJSON([
                'success' => true,
                'results' => [],
                'count' => 0
            ]);
        }

        $cfPlaceholders = implode(',', array_fill(0, count($cfCodes), '?'));

        $query = "
            SELECT 
                d.\"id_del\",
                d.\"numDef\",
                d.\"loginReception\",
                d.\"dateReception\",
                d.\"loginClotureDel\",
                d.\"dateClotureDel\",
                d.\"decisionforme\",
                d.\"decisionfond\",
                d.\"decisionfinale\",
                d.\"decisionObs\",
                d.\"etatDelVerif\",
                d.\"etatVerif2\",
                d.\"etat\",
                sa.\"id_secretaire\",
                e.\"bdef\",
                e.\"objet\",
                e.\"montant\",
                e.\"exercice\",
                sa.\"refCF\"
            FROM \"del_aller1\" d
            LEFT JOIN \"secretaire_aller1\" sa ON d.\"numDef\" = sa.\"numDef\"
            LEFT JOIN \"engagement\" e ON d.\"numDef\" = e.\"numDef\"
            WHERE e.\"cf_code\" IN ({$cfPlaceholders})
              AND e.\"exercice\" = ?
              AND d.\"etatDelVerif\" = 'Cloturer'
              AND NOT EXISTS (
                  SELECT 1 FROM \"verif_aller1\" v
                  WHERE v.\"numDef\" = d.\"numDef\"
                    AND v.\"loginReception2\" != ''
                    AND v.\"loginReception2\" IS NOT NULL
              )
        ";

        $params = [...$cfCodes, $annee];

        if ($search !== '%' && !empty($search)) {
            $query .= " AND (
                d.\"numDef\" LIKE ? 
                OR e.\"bdef\" LIKE ? 
                OR e.\"objet\" LIKE ? 
                OR sa.\"refCF\" LIKE ?
            )";
            $params[] = "%{$search}%";
            $params[] = "%{$search}%";
            $params[] = "%{$search}%";
            $params[] = "%{$search}%";
        }

        $query .= " ORDER BY d.\"dateClotureDel\" DESC";

        $results = $db->query($query, $params)->getResultArray();

        return $this->response->setJSON([
            'success' => true,
            'results' => $results,
            'count' => count($results)
        ]);

    } catch (\Exception $e) {
        return $this->response->setJSON([
            'success' => false,
            'error' => $e->getMessage()
        ]);
    }
}


public function receptionDelegue()
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

        $updatedCount = 0;
        $dateReception = date('Y-m-d H:i:s');

        foreach ($selectedEngagements as $engagement) {
            $numDef = $engagement['numDef'] ?? '';
            $decisionFinale = $engagement['decisionfinale'] ?? '';

            if (!$numDef) {
                continue;
            }

            // Vérifier si l'enregistrement existe dans verif_aller1
            $existing = $db->query(
                'SELECT * FROM "verif_aller1" WHERE "numDef" = ?',
                [$numDef]
            )->getRowArray();

            if (!$existing) {
                continue;
            }

            // Mettre à jour loginReception2, dateReception2 et decision
            $db->query("
                UPDATE \"verif_aller1\" 
                SET 
                    \"loginReception2\" = ?,
                    \"dateReception2\" = ?,
                    \"decision\" = ?
                WHERE \"numDef\" = ?
            ", [
                $immatricule,
                $dateReception,
                $decisionFinale,
                $numDef
            ]);

            $updatedCount++;
        }

        return $this->response->setJSON([
            'success' => true,
            'message' => 'Réception effectuée avec succès',
            'total' => $updatedCount
        ]);

    } catch (\Exception $e) {
        return $this->response->setJSON([
            'success' => false,
            'error' => $e->getMessage()
        ]);
    }
}

public function getReceivedDelegateEngagements()
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

        $query = "
            SELECT 
                v.\"id_verif\",
                v.\"numDef\",
                v.\"loginReception2\",
                v.\"dateReception2\",
                v.\"decision\",
                sa.\"refCF\",
                e.\"bdef\",
                e.\"objet\",
                e.\"montant\",
                e.\"exercice\"
            FROM \"verif_aller1\" v
            LEFT JOIN \"secretaire_aller1\" sa ON v.\"numDef\" = sa.\"numDef\"
            LEFT JOIN \"engagement\" e ON v.\"numDef\" = e.\"numDef\"
            WHERE v.\"loginReception2\" IS NOT NULL
              AND v.\"loginReception2\" != ''
              AND v.\"loginReception2\" = ?
              AND e.\"exercice\" = ?
            ORDER BY v.\"dateReception2\" DESC
        ";

        $results = $db->query($query, [$immatricule, $annee])->getResultArray();

        return $this->response->setJSON([
            'success' => true,
            'results' => $results,
            'count' => count($results)
        ]);

    } catch (\Exception $e) {
        return $this->response->setJSON([
            'success' => false,
            'error' => $e->getMessage()
        ]);
    }
}
}