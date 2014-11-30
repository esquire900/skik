# Skik
**View online at [skikapp.com](http://skikapp.com)**

Skik is the hackable newsreader that updates you on your favourite programming languages!

I created skik for the danish [Geek Challenge](htpp://www.geekchallenge.dk), and decided to opensource it in case it might be useful to someone else.

## Get running
If you are an end user, go to skikapp.com. 

### API
If you are a developer, you should get a php/mysql combination running locally (or on your server), and create a database from the latest sql dump (api/db_designs). Then create api/config/db.php and fill it with the following:

````
<?php

return [
    'class' => 'yii\db\Connection',
    'dsn' => 'mysql:host=DB_HOST;dbname=DB_NAME',
    'username' => 'DB_USER',
    'password' => 'DB_PASSWORD',
    'charset' => 'utf8',
];
````

After that, run "php composer.phar install" to install all the dependencies for the api. If you are not familiar with composer, install it from [getcomposer.org](https://getcomposer.org/). The backend is build with [Yii2](http://www.yiiframework.com/doc-2.0/guide-README.html). If you run into trouble, try

`` php composer.phar global require "fxp/composer-asset-plugin:1.0.0-beta1" `` 

### Website

The frontend (app/) is written in coffeescript and stylus, and uses angular as a framework. To get developing, run "bower install" and "npm install" in the /app folder. If you are not familiar with either nodejs or bower, google both and prepare for an afternoon of javascript awesomeness ;)

After installing, you should be able to run the command "gulp serve", which watches all the changes and converts the coffee & stylus scripts. It also supports the livereload plugin for chrome. Point your browser to (host)/(path_to_skik)/app/app/dev.html and get cracking! Remember to change the api baseurl in scripts/comp/api.coffee to your own backend url.

## License

Licensed under creative [commons 4.0](https://creativecommons.org/licenses/by/4.0/)