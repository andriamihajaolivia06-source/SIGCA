<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class DelegateController extends ResourceController
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

            // Récupérer les engagements clôturés par le vérificateur (etatVerifDel = 'Cloturer')
            // et qui n'ont pas encore été réceptionnés par le délégué
            $query = "
                SELECT 
                    v.\"id_verif\",
                    v.\"id_secretaire\",
                    v.\"numDef\",
                    v.\"loginReception\",
                    v.\"dateReception\",
                    v.\"forme\",
                    v.\"fond\",
                    v.\"proposition\",
                    v.\"observations\",
                    v.\"etatVerifDel\",
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
                FROM \"verif_aller1\" v
                LEFT JOIN \"secretaire_aller1\" sa ON v.\"id_secretaire\" = sa.\"id_secretaire\"
                LEFT JOIN \"engagement\" e ON v.\"numDef\" = e.\"numDef\"
                WHERE e.\"cf_code\" = ?
                  AND e.\"exercice\" = ?
                  AND v.\"etatVerifDel\" = 'Cloturer'
                  AND NOT EXISTS (
                      SELECT 1 FROM \"del_aller1\" d
                      WHERE d.\"numDef\" = v.\"numDef\"
                  )
            ";

            $params = [$cfCode, $annee];

            if (!empty($search) && $search !== '%') {
                $query .= " AND (
                    v.\"numDef\" LIKE ? 
                    OR e.\"bdef\" LIKE ? 
                    OR sa.\"refCF\" LIKE ? 
                    OR e.\"objet\" LIKE ?
                )";
                $params[] = "%{$search}%";
                $params[] = "%{$search}%";
                $params[] = "%{$search}%";
                $params[] = "%{$search}%";
            }

            $query .= " ORDER BY v.\"dateCloture\" DESC";

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
     * POST /api/delegate/reception
     */
    public function reception()
    {
        $data = $this->request->getJSON(true);

        $immatricule = $data['immatricule'] ?? null;
        $annee = $data['annee'] ?? null;
        $cfCode = $data['cf_code'] ?? null;
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
            $dateReception = date('Y-m-d');

            foreach ($selectedEngagements as $engagement) {
                $numDef = $engagement['numDef'] ?? '';

                if (!$numDef) {
                    continue;
                }

                // Vérifier si déjà réceptionné
                $existing = $db->table('del_aller1')
                    ->where('numDef', $numDef)
                    ->get()
                    ->getRowArray();

                if (!$existing) {
                    $db->table('del_aller1')->insert([
                        'numDef' => $numDef,
                        'loginReception' => $immatricule,
                        'dateReception' => $dateReception,
                        'loginClotureDel' => '',
                        'dateClotureDel' => $dateReception,
                        'decisionforme' => '',
                        'decisionfond' => '',
                        'decisionfinale' => '',
                        'decisionObs' => '',
                        'instructions' => null,
                        'etatDelVerif' => 'Noncloturer',
                        'etatVerif2' => 0,
                        'etat' => 0
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
                    d.\"id_del\",
                    d.\"numDef\",
                    d.\"loginReception\",
                    d.\"dateReception\",
                    d.\"etatDelVerif\",
                    sa.\"refCF\",
                    sa.\"loginReception1\",
                    sa.\"dateReception1\",
                    sa.\"etatSecVerif\",
                    e.\"bdef\",
                    e.\"objet\",
                    e.\"montant\",
                    e.\"exercice\"
                FROM \"del_aller1\" d
                LEFT JOIN \"secretaire_aller1\" sa ON d.\"numDef\" = sa.\"numDef\"
                LEFT JOIN \"engagement\" e ON d.\"numDef\" = e.\"numDef\"
                WHERE d.\"loginReception\" = ?
                  AND d.\"etatDelVerif\" = 'Noncloturer'
                ORDER BY d.\"dateReception\" DESC
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


public function getNonClosedBySecretary()
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

        $user = $db->query("
            SELECT cf_code FROM user_multiple
            WHERE TRIM(im_utilisateur) = ? AND TRIM(exercice) = ?
            LIMIT 1
        ", [$immatricule, $annee])->getRowArray();

        if (!$user) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Utilisateur non trouvé'
            ]);
        }

        // cf_code de user_multiple contient en réalité des id_delegation (ex: "47" ou "51,5")
        $idDelegations = array_map('trim', explode(',', $user['cf_code']));
        $idDelegations = array_filter($idDelegations);
        $idDelegations = array_map('intval', $idDelegations);

        if (empty($idDelegations)) {
            return $this->response->setJSON(['success' => true, 'results' => [], 'count' => 0]);
        }

        $idPlaceholders = implode(',', array_fill(0, count($idDelegations), '?'));
        $delegations = $db->query("
            SELECT cf_code FROM delegation WHERE id_delegation IN ({$idPlaceholders})
        ", $idDelegations)->getResultArray();

        $cfCodes = array_filter(array_map(fn($d) => trim($d['cf_code']), $delegations));

        if (empty($cfCodes)) {
            return $this->response->setJSON(['success' => true, 'results' => [], 'count' => 0]);
        }

        $cfPlaceholders = implode(',', array_fill(0, count($cfCodes), '?'));

        $query = "
            SELECT 
                sa.\"id_secretaire\",
                sa.\"numDef\",
                sa.\"refCF\",
                sa.\"loginReception1\",
                sa.\"dateReception1\",
                sa.\"etatSecVerif\",
                sa.\"etatVerif\",
                e.\"bdef\",
                e.\"objet\",
                e.\"montant\",
                e.\"exercice\"
            FROM \"secretaire_aller1\" sa
            LEFT JOIN \"engagement\" e ON sa.\"numDef\" = e.\"numDef\"
            WHERE TRIM(e.\"cf_code\") IN ({$cfPlaceholders})
              AND e.\"exercice\" = ?
              AND sa.\"etatVerif\" = 0
            ORDER BY sa.\"dateReception1\" DESC
        ";

        $params = array_merge($cfCodes, [$annee]);
        $results = $db->query($query, $params)->getResultArray();

        return $this->response->setJSON([
            'success' => true,
            'results' => $results,
            'count' => count($results)
        ]);

    } catch (\Exception $e) {
        return $this->response->setJSON(['success' => false, 'error' => $e->getMessage()]);
    }
}

public function getNonClosedByVerificateur()
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

        $user = $db->query("
            SELECT cf_code FROM user_multiple
            WHERE TRIM(im_utilisateur) = ? AND TRIM(exercice) = ?
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

        if (empty($idDelegations)) {
            return $this->response->setJSON(['success' => true, 'results' => [], 'count' => 0]);
        }

        $idPlaceholders = implode(',', array_fill(0, count($idDelegations), '?'));
        $delegations = $db->query("
            SELECT cf_code FROM delegation WHERE id_delegation IN ({$idPlaceholders})
        ", $idDelegations)->getResultArray();

        $cfCodes = array_filter(array_map(fn($d) => trim($d['cf_code']), $delegations));

        if (empty($cfCodes)) {
            return $this->response->setJSON(['success' => true, 'results' => [], 'count' => 0]);
        }

        $cfPlaceholders = implode(',', array_fill(0, count($cfCodes), '?'));

        $query = "
            SELECT 
                v.\"id_verif\",
                v.\"numDef\",
                v.\"loginReception\",
                v.\"dateReception\",
                v.\"etatVerifDel\",
                sa.\"refCF\",
                e.\"bdef\",
                e.\"objet\",
                e.\"montant\",
                e.\"exercice\"
            FROM \"verif_aller1\" v
            LEFT JOIN \"secretaire_aller1\" sa ON v.\"id_secretaire\" = sa.\"id_secretaire\"
            LEFT JOIN \"engagement\" e ON v.\"numDef\" = e.\"numDef\"
            WHERE TRIM(e.\"cf_code\") IN ({$cfPlaceholders})
              AND e.\"exercice\" = ?
              AND v.\"etatVerifDel\" = 'Noncloturer'
            ORDER BY v.\"dateReception\" DESC
        ";

        $params = array_merge($cfCodes, [$annee]);
        $results = $db->query($query, $params)->getResultArray();

        return $this->response->setJSON([
            'success' => true,
            'results' => $results,
            'count' => count($results)
        ]);

    } catch (\Exception $e) {
        return $this->response->setJSON(['success' => false, 'error' => $e->getMessage()]);
    }
}

   public function getVerificationDetails()
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

            // 1. Récupérer la vérification depuis verif_aller1
            $verification = $db->query("
                SELECT 
                    v.\"id_verif\",
                    v.\"id_secretaire\",
                    v.\"numDef\",
                    v.\"loginReception\",
                    v.\"dateReception\",
                    v.\"forme\",
                    v.\"fond\",
                    v.\"proposition\",
                    v.\"observations\",
                    v.\"loginCloture\",
                    v.\"dateCloture\",
                    v.\"etatVerifDel\",
                    sa.\"refCF\",
                    e.\"bdef\",
                    e.\"objet\",
                    e.\"montant\",
                    e.\"exercice\"
                FROM \"verif_aller1\" v
                LEFT JOIN \"secretaire_aller1\" sa ON v.\"id_secretaire\" = sa.\"id_secretaire\"
                LEFT JOIN \"engagement\" e ON v.\"numDef\" = e.\"numDef\"
                WHERE v.\"numDef\" = ?
                LIMIT 1
            ", [$numDef])->getRowArray();

            if (!$verification) {
                return $this->response->setJSON([
                    'success' => true,
                    'verification' => null,
                    'pieces' => [],
                    'motifs' => []
                ]);
            }

            // 2. Récupérer les pièces vérifiées depuis tbl_verifcloture
            $pieces = $db->query("
                SELECT 
                    vc.\"id_piece\",
                    p.\"pj\"
                FROM \"tbl_verifcloture\" vc
                LEFT JOIN \"piece\" p ON vc.\"id_piece\" = p.\"id_piece\"
                WHERE vc.\"engverifcloture\" = ?
            ", [$numDef])->getResultArray();

            // Formater les pièces avec checked = true
            $formattedPieces = array_map(function($p) {
                return [
                    'id_piece' => $p['id_piece'],
                    'pj' => $p['pj'] ?? 'Pièce',
                    'checked' => true
                ];
            }, $pieces);

            // 3. Récupérer les motifs sélectionnés depuis temp_motif
            $motifIds = $db->query("
                SELECT \"id_motif\" FROM \"temp_motif\" WHERE \"numDef\" = ?
            ", [$numDef])->getResultArray();
            $motifIds = array_column($motifIds, 'id_motif');

            // 4. Récupérer tous les motifs pour les labels
            $allMotifs = $db->table('motif')
                ->orderBy('id_motif', 'ASC')
                ->get()
                ->getResultArray();

            // Ajouter les motifs à la vérification
            $verification['motif_ids'] = $motifIds;

            return $this->response->setJSON([
                'success' => true,
                'verification' => $verification,
                'pieces' => $formattedPieces,
                'motifs' => $allMotifs
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }
}