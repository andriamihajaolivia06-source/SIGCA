<?php

namespace App\Controllers;

use App\Models\UserMultipleModel;
use CodeIgniter\RESTful\ResourceController;

class AuthController extends ResourceController
{
    protected $format = 'json';

    public function options()
    {
        $db = db_connect();

        $years = $db->table('user_multiple')
            ->select('exercice')
            ->distinct()
            ->orderBy('exercice', 'DESC')
            ->get()
            ->getResultArray();

        $roles = $db->table('user_multiple')
            ->select('role')
            ->distinct()
            ->orderBy('role', 'ASC')
            ->get()
            ->getResultArray();

        return $this->respond([
            'success' => true,
            'annees' => array_column($years, 'exercice'),
            'roles' => array_column($roles, 'role')
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

        $model = new UserMultipleModel();

        $user = $model
            ->where('exercice', $annee)
            ->where('im_utilisateur', $immatricule)
            ->where('role', $role)
            ->where('etat', 'actif')
            ->first();

        if (!$user) {
            return $this->failUnauthorized(
                'Immatricule, mot de passe, année ou rôle incorrect.'
            );
        }

        if ($user['mot_passe'] !== $motDePasse) {
            return $this->failUnauthorized(
                'Immatricule, mot de passe, année ou rôle incorrect.'
            );
        }

        return $this->respond([
            'success' => true,

            'message' => 'Connexion réussie.',

            'user' => [
                'id' => $user['id_utilisateur'],
                'nom' => trim($user['nom_utilisateur']),
                'prenom' => trim($user['prenom_utilisateur']),
                'immatricule' => $user['im_utilisateur'],
                'role' => $user['role'],
                'annee' => $user['exercice'],
                'compte' => $user['compte']
            ]
        ]);
    }
}