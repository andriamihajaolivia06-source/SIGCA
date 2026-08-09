<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */
$routes->get('/', 'Home::index');


$routes->get('api/auth/options', 'AuthController::options');
$routes->post('api/auth/login', 'AuthController::login');

// routes pour secretaires
$routes->get('api/secretary/delegations', 'SecretaryController::delegations');
$routes->get('api/secretary/search-bdef', 'SecretaryController::searchBdef');
$routes->get('api/secretary/search-def', 'SecretaryController::searchDef');
$routes->get('api/secretary/search-deg', 'SecretaryController::searchDeg');
$routes->post('api/secretary/validate', 'SecretaryController::validateEngagements');
$routes->get('api/secretary/validated-engagements', 'SecretaryController::getValidatedEngagements');
$routes->post('api/secretary/close-engagements', 'SecretaryController::closeEngagements');
$routes->get('api/secretary/closed-engagements', 'SecretaryController::getClosedEngagements');

// routes pour verificateurs
$routes->get('api/verificateur/delegations', 'VerificateurController::delegations');
$routes->get('api/verificateur/search-closed', 'VerificateurController::searchClosed');