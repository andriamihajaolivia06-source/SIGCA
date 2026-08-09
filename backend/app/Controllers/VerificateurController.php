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

            // Récupérer le cf_code correspondant à l'id_delegation
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

            // Construire la requête
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
            ";

            $params = [$cfCode, $annee];

            // Si la recherche n'est pas vide et différente de '%'
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
}