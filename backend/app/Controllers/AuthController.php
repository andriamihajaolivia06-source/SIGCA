<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class AuthController extends ResourceController
{
    protected $format = 'json';

    public function options()
    {
        $db = db_connect();

       
        $years = $db->query("
            SELECT DISTINCT TRIM(exercice) as exercice 
            FROM user_multiple 
            WHERE TRIM(etat) = 'actif'
              AND TRIM(exercice) IS NOT NULL
              AND TRIM(exercice) != ''
            ORDER BY exercice DESC
        ")->getResultArray();

      
        $roles = $db->query("
            SELECT DISTINCT TRIM(role) as role 
            FROM user_multiple 
            WHERE TRIM(etat) = 'actif'
              AND TRIM(role) IS NOT NULL
              AND TRIM(role) != ''
            ORDER BY role ASC
        ")->getResultArray();

        $allYears = array_column($years, 'exercice');
        $allRoles = array_column($roles, 'role');

        return $this->respond([
            'success' => true,
            'annees' => $allYears,
            'roles' => $allRoles
        ]);
    }

    public function login()
    {
        $data = $this->request->getJSON(true);

        $annee = $data['annee'] ?? null;
        $immatricule = trim($data['immatricule'] ?? '');
        $motDePasse = $data['motDePasse'] ?? '';
        $role = trim($data['role'] ?? '');

    
        if (!$annee || !$immatricule || !$motDePasse || !$role) {
            return $this->failValidationErrors(
                'Tous les champs sont obligatoires.'
            );
        }

        $db = db_connect();

        
        $user = $db->query("
            SELECT *
            FROM user_multiple
            WHERE TRIM(exercice) = ?
              AND TRIM(im_utilisateur) = ?
              AND TRIM(role) = ?
              AND TRIM(etat) = 'actif'
            LIMIT 1
        ", [$annee, $immatricule, $role])->getRowArray();

        if (!$user) {
            return $this->failUnauthorized(
                'Immatricule, mot de passe, année ou rôle incorrect.'
            );
        }

     
        if (trim($user['mot_passe']) !== $motDePasse) {
            return $this->failUnauthorized(
                'Immatricule, mot de passe, année ou rôle incorrect.'
            );
        }

     
        $token = base64_encode(json_encode([
            'id' => $user['id_utilisateur'],
            'role' => $user['role'],
            'immatricule' => $user['im_utilisateur'],
            'exp' => time() + 3600 * 8
        ]));

        return $this->respond([
            'success' => true,
            'message' => 'Connexion réussie.',
            'user' => [
                'id' => $user['id_utilisateur'],
                'nom' => trim($user['nom_utilisateur']),
                'prenom' => trim($user['prenom_utilisateur']),
                'immatricule' => trim($user['im_utilisateur']),
                'role' => trim($user['role']),
                'annee' => trim($user['exercice']),
                'compte' => $user['compte'] ?? 'SIMPLE',
                'cf_code' => $user['cf_code'] ?? '',
                'token' => $token
            ]
        ]);
    }
}