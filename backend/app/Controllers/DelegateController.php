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
}