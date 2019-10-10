---
title: "Deploy Symfony 4 on Dokku"
date: 2019-10-08T17:46:10+08:00
keywords: []
description: ""
tags: ['symfony', 'dokku']
categories: []
resources:
    - title: 'Deploying Symfony 4 Apps on Heroku'
      url: https://devcenter.heroku.com/articles/deploying-symfony4
    - title: 'Deploying to Heroku Cloud'
      url: https://symfony.com/doc/3.4/deployment/heroku.html
---

Been recently playing around with [Dokku](http://dokku.viewdocs.io/dokku/), a heroku-like, selfhosted PaaS solution for servers. I've wanted to test out deployment of Symfony 4 on Dokku. In order to do this, I tried deploying the [`demo`](https://github.com/symfony/demo) project from Symfony.

First thing I did was to add the project locally:

```shell
$ symfony new --demo demo
```

I then created the app on the server, created the `mariadb` service, and linked the `mariadb` service to the newly created app on the server:

```shell
$ dokku apps:create symfony-demo
$ dokku mariadb:create symfony-demo
$ dokku mariadb:link symfony-demo symfony-demo
```

> I have already installed the [`mariadb`](https://github.com/dokku/dokku-mariadb) plugin for dokku.

<!-- -->
> The `demo` project actually uses `sqlite` as its database.

At this point, `dokku` sets the `DATABASE_URL` environment variable which is, by default, also used by Symfony/Doctrine.

I would also need to set the `APP_ENV` variable for Symfony to `prod` so that no packages are included for development since the `php` buildpack by Heroku [does not install the development packages](https://devcenter.heroku.com/articles/php-support#installation-of-dependencies).

```shell
$ dokku config:set symfony-demo APP_ENV=prod
```

The `demo` project uses `nodejs` for building the frontend. `dokku` tries its best to determine what buildpack to use during deployment i.e. whether it sees a `composer.json` or `package.json` file. In order to get the project working, I needed 2 [buildpacks](http://dokku.viewdocs.io/dokku~v0.18.5/deployment/methods/buildpacks/):

* Node.js
* PHP

There are [multiple ways](http://dokku.viewdocs.io/dokku~v0.18.5/deployment/methods/buildpacks/) for `dokku` to detect the correct buildpacks. For this deployment, I've decided to just use the `.buildpacks` file to specify what buildpacks should do `dokku` use for deployment:

```
https://github.com/heroku/heroku-buildpack-nodejs.git
https://github.com/heroku/heroku-buildpack-php.git
```

> The versions can be specified in the [`composer.json`](https://devcenter.heroku.com/articles/php-support#selecting-a-runtime) file for PHP and [`package.json`](https://devcenter.heroku.com/articles/nodejs-support#specifying-a-node-js-version) file for Node.js.

These are only the steps I needed in the server to prepare for deployment. The additional changes I've added on the project were:

* Add a `Procfile` file in the root directory.
* Add `apache-pack` package.
* Replace `pdo_sqlite` with `pdo_mysql`.
* Update the configuration for Doctrine to use MySQL as the driver.

For the `Procfile`, the only change needed was to set the document root to 'public' since Symfony uses this as its front controller. [Changing the document root](https://devcenter.heroku.com/articles/custom-php-settings#setting-the-document-root) is simple as well:

```
web: vendor/bin/heroku-php-apache2 public/
```

The other remaining changes are Symfony specific:

1. Execute `composer require apache-pack`.
2. Replace `pdo_sqlite` with `pdo_mysql` in the `composer.json` file and do `composer update`:

   ```diff
   - "ext-pdo_sqlite": "*",
   + "ext-pdo_mysql": "*",
   ```
3. Change configuration to use MySQL in the config/packages/doctrine.yaml file:

   ```diff
   - driver: 'pdo_sqlite'
   - server_version: '3.15'
   - charset: utf8mb4
   + driver: pdo_mysql
   ```

After setting everything up, I simply needed to just commit all changes and push them to the server to trigger the build.

Deployment to `dokku` is very simple. Speed depends on the server though. Building was a little slow and there are instances where `dokku` would just freeze during deployment --- maybe due to low memory. Other than that, deployment is very smooth.
