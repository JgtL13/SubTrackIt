<?php

require_once __DIR__ . '/../vendor/autoload.php';

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

$settings = [
    'db' => [
        'host' => '127.0.0.1',
        'dbname' => 'SubTrackIt',
        'user' => 'root',
        'pass' => ''
    ]
];

// Create Slim app
$app = AppFactory::create();
$container = $app->getContainer();
$container['db'] = function ($c) {
    $db = $c['settings']['db'];
    $pdo = new PDO('mysql:host=' . $db['host'] . ';dbname=' . $db['dbname'],
        $db['user'], $db['pass']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    return $pdo;
};

$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write('Hello World!');
    return $response;
});

// Define a route for GET requests
$app->get('/providers', function (Request $request, Response $response, $args) {
    // Create response array
    $responseData = array();

    // Retrieve providers from the database
    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $providers = $db->getProviders();

    // Check if providers were retrieved successfully
    if ($providers !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $providers;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve providers from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
    //return $response;
});

$app->get('/plans/{provider}', function (Request $request, Response $response, $args) {
    // Create response array
    $provider = (String)$args['provider'];
    $responseData = array();

    // Retrieve providers from the database
    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $plans = $db->getPlans($provider);

    // Check if providers were retrieved successfully
    if ($plans !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $plans;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve providers from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
    //return $response;
});

$app->get('/subscriptions', function (Request $request, Response $response, $args) {
    $user_id = $request->getHeaderLine('User-ID');
    //$subscription_id = (int)$args['id'];

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $subscriptions = $db->getSubscriptions($user_id, -1);

    if ($subscriptions !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $subscriptions;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve providers from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->get('/dashboard', function (Request $request, Response $response, $args) {
    //$dashboard_id = (int)$args['id'];
    $user_id = $request->getHeaderLine('User-ID');

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $subscriptions = $db->getSubscriptions($user_id, 7);

    if ($subscriptions !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $subscriptions;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve providers from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->post('/newSubscription', function (Request $request, Response $response, $args) {
    $jsonString = $request->getBody()->getContents();

    // Decode the JSON string into an associative array
    $parsedBody = json_decode($jsonString, true);

    // Check if JSON decoding was successful
    if ($parsedBody === null) {
        // Handle invalid JSON data
        $responseData['error'] = true;
        $responseData['message'] = "Invalid JSON data";
    } else {
        // Extract the data from the parsed JSON body
        $Start_date = $parsedBody['Start_date'] ?? null;
        $Free_trial = $parsedBody['Free_trial'] ?? null;
        $User_ID = $parsedBody['User_ID'] ?? null;
        $Plan_ID = $parsedBody['Plan_ID'] ?? null;
    }

    echo "!Start_date: " . $Start_date . "\n";
    echo "!Free_trial: " . $Free_trial . "\n";
    echo "!User_ID: " . $User_ID . "\n";
    echo "!Plan_ID: " . $Plan_ID . "\n";

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $result = $db->newSubscription($Start_date, $Free_trial, $User_ID, $Plan_ID);

    // Check if the subscription was added successfully
    if ($result !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['message'] = "Subscription added successfully";
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to add subscription";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->delete('/deleteSubscription', function (Request $request, Response $response, $args) {
    $subscription_id = $request->getHeaderLine('Subscription-ID');
    //$subscription_id = (int)$args['id'];

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $subscriptions = $db->deleteSubscription($subscription_id);

    if ($subscriptions !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $subscriptions;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to delete subscription from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->put('/renewSubscription', function (Request $request, Response $response, $args) {
    $subscription_id = $request->getHeaderLine('Subscription-ID');
    //$subscription_id = (int)$args['id'];

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $subscriptions = $db->renewSubscription($subscription_id);

    if ($subscriptions !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $subscriptions;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to renew subscription from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->post('/createUser', function (Request $request, Response $response, $args) {
    $deviceToken = $request->getHeaderLine('deviceToken');
    $user_id = $request->getHeaderLine('User-ID');
    //$subscription_id = (int)$args['id'];

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $user = $db->createUser($user_id, $deviceToken);

    if ($user !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $user;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to renew subscription from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->get('/getUsername', function (Request $request, Response $response, $args) {
    //$dashboard_id = (int)$args['id'];
    $user_id = $request->getHeaderLine('User-ID');

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $username = $db->getUsername($user_id);

    if ($username !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $username;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve username from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->get('/syncData', function (Request $request, Response $response, $args) {
    //$dashboard_id = (int)$args['id'];
    $email = $request->getHeaderLine('email');
    $password = $request->getHeaderLine('password');

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $userID = $db->syncData("", $email, $password, "", "GET");

    if ($userID !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $userID;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve username from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->post('/syncData', function (Request $request, Response $response, $args) {
    //$dashboard_id = (int)$args['id'];
    $email = $request->getHeaderLine('email');
    $password = $request->getHeaderLine('password');
    $userID = $request->getHeaderLine('User-ID');

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $user = $db->syncData("", $email, $password, $userID, "POST");

    if ($user !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $user;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve username from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->put('/syncData', function (Request $request, Response $response, $args) {
    //$dashboard_id = (int)$args['id'];
    $username = $request->getHeaderLine('username');
    $userID = $request->getHeaderLine('User-ID');

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $user = $db->syncData($username, "", "", $userID, "PUT");

    if ($user !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $user;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve username from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->put('/notificationSetup', function (Request $request, Response $response, $args) {
    //$dashboard_id = (int)$args['id'];
    $deviceToken = $request->getHeaderLine('deviceToken');
    $userID = $request->getHeaderLine('User-ID');

    require_once '../include/DbOperation.php';
    $db = new DbOperation(); // Assuming DbOperation is properly defined
    $user = $db->notificationSetup($userID, $deviceToken ,"PUT");

    if ($user !== null) {
        // Generating response for success
        $responseData['error'] = false;
        $responseData['data'] = $user;
    } else {
        // Generating response for error
        $responseData['error'] = true;
        $responseData['message'] = "Failed to retrieve username from the database";
    }

    // Set response content type
    $response->getBody()->write(json_encode($responseData));
    return $response->withHeader('Content-Type', 'application/json');
});

// Run the Slim app
$app->run();