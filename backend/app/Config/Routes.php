<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */
$routes->get('/', 'Home::index');

// Routes d'authentification
$routes->get('api/auth/options', 'AuthController::options');
$routes->post('api/auth/login', 'AuthController::login');

// Routes du secrétaire
$routes->get('api/secretary/delegations', 'SecretaryController::delegations');
$routes->get('api/secretary/search-bdef', 'SecretaryController::searchBdef');
$routes->get('api/secretary/search-def', 'SecretaryController::searchDef');
$routes->post('api/secretary/validate', 'SecretaryController::validateEngagements');
$routes->get('api/secretary/validated-engagements', 'SecretaryController::getValidatedEngagements');
$routes->post('api/secretary/close-engagements', 'SecretaryController::closeEngagements');
$routes->get('api/secretary/closed-engagements', 'SecretaryController::getClosedEngagements');

// Routes du vérificateur
$routes->get('api/verificateur/delegations', 'VerificateurController::delegations');
$routes->get('api/verificateur/search-closed', 'VerificateurController::searchClosed');
$routes->post('api/verificateur/reception', 'VerificateurController::reception');
$routes->get('api/verificateur/received-engagements', 'VerificateurController::getReceivedEngagements');
$routes->get('api/verificateur/engagement-details', 'VerificateurController::getEngagementDetails');
$routes->get('api/verificateur/motifs', 'VerificateurController::getMotifs');
$routes->post('api/verificateur/save-verification', 'VerificateurController::saveVerification');

// Routes du délégué
$routes->get('api/delegate/delegations', 'DelegateController::delegations');
$routes->get('api/delegate/search-closed', 'DelegateController::searchClosed');
$routes->post('api/delegate/reception', 'DelegateController::reception');
$routes->get('api/delegate/received-engagements', 'DelegateController::getReceivedEngagements');