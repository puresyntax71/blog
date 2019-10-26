---
title: "Minimal Local Drupal Setup with Drupal VM and Composer"
date: 2019-10-25T16:20:58+08:00
keywords: []
description: ""
tags: ['drupal', 'development', 'tools']
categories: []
resources: []
---

One of the good things I really like about Drupal is its ecosystem. With a large community, you'll find that a lot of smart people were able to contribute integrations with Drupal. Amongst these is its tooling - from debugging to testing to local environments. Here I would show a minimal local drupal development setup.

When it comes to local environment, Drupal has a lot of options to choose from. You can have a really simple LAMP/LEMP setup or a VM. There is a [huge list](https://www.drupal.org/docs/develop/local-server-setup) which provides different forms of setup.

I've opted for [Drupal VM](https://www.drupalvm.com/). It's been around for ages and is actively being maintained. It may not be as 'minimal' as it should considering it has support for a lot of services although I find it really clean to configure. By default, Drupal VM uses [Vagrant](https://www.vagrantup.com) and [Ansible](https://www.ansible.com) to create a local environment.

There are [different ways](http://docs.drupalvm.com/en/latest/) to use Drupal VM with Drupal and I've found including it as a [dependency in composer](http://docs.drupalvm.com/en/latest/deployment/composer-dependency/) much cleaner and flexible.

To get it setup, I've first created a Drupal project using [drupal-composer/drupal-project](https://github.com/drupal-composer/drupal-project):

```shell
$ composer create-project drupal-composer/drupal-project:8.x-dev my_drupal --no-interaction
```

I then included Drupal VM as a dependency in `composer`:

```shell
$ composer require --dev geerlingguy/drupal-vm
```

In order to configure Drupal VM, I've added a file `config/config.yml` from the project's root directory. Drupal VM tries to locate the file `config.yml` so it can be from [anywhere](http://docs.drupalvm.com/en/latest/deployment/composer-dependency/#setup-your-configuration-files):

```yaml
vagrant_hostname: my_drupal.local
vagrant_machine_name: my_drupal
vagrant_ip: 192.168.88.88

drupal_build_makefile: false
drupal_build_composer: false
drupal_build_composer_project: false
drupal_install_site: false

drupal_core_path: "/var/www/drupalvm/web"
```

What I did here is that I've specified Vagrant specific configurations, told Drupal VM not to do any of its automated installation, and set the document root of Drupal. The default configurations can be found [here](https://github.com/geerlingguy/drupal-vm/blob/master/default.config.yml).

After getting this set up, all I needed to do was `vagrant up` and left Drupal VM to it. I already have Vagrant plugin `vagrant-hostsupdater` installed locally - Drupal VM uses this to update the hosts file to point "my_drupal.local" to the configured IP (192.168.88.88).

Once Vagrant/Drupal VM has finished provisioning I would have the following services for my local environment:

* Adminer
* XHProf
* Dashboard - simple dashboard by Drupal VM to manage websites
* Pimp my log
* Drupal - the actual site.
