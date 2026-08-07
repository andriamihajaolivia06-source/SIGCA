<?php

namespace App\Models;

use CodeIgniter\Model;

class UserMultipleModel extends Model
{
    protected $table = 'user_multiple';

    protected $primaryKey = 'id_utilisateur';

    protected $returnType = 'array';

    protected $allowedFields = [
        'nom_utilisateur',
        'prenom_utilisateur',
        'im_utilisateur',
        'role',
        'compte',
        'login',
        'mot_passe',
        'cf_code',
        'date_creation',
        'exercice',
        'etat'
    ];
}