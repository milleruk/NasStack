<?php

use League\Container\Container;
use New3den\Console\Console;

$autoloader = require_once(__DIR__ . '/vendor/autoload.php');

$container = new Container();
$container->delegate(new \League\Container\ReflectionContainer);

$cli = new Console($container, $autoloader);
$cli->setCommandsNamespace('NASStack\Commands');
$cli->setConsoleName('NASStack');
$cli->setVersion('1.0.0');

$cli->run();
