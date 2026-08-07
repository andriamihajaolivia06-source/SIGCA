<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */
$routes->get('/', 'Home::index');


$routes->get('api/auth/options', 'AuthController::options');
$routes->post('api/auth/login', 'AuthController::login');


$routes->get('api/secretary/delegations', 'SecretaryController::delegations');
$routes->get('api/secretary/search-bdef', 'SecretaryController::searchBdef');
$routes->get('api/secretary/search-def', 'SecretaryController::searchDef');
$routes->get('api/secretary/search-deg', 'SecretaryController::searchDeg');

$routes->post('api/secretary/validate', 'SecretaryController::validate');