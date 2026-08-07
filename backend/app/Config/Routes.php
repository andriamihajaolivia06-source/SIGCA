<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */
$routes->get('/', 'Home::index');
$routes->get('api/auth/options', 'AuthController::options');
$routes->post('api/auth/login', 'AuthController::login');
