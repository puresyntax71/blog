---
categories: development
date: 2015-04-07T00:00:00Z
title: PHP, Coder, and Code Sniffer in OS X
tags: []
---

### PHP

I originally used the PHP package bundled with OS X. This doesn't seem to be easily maintainable since you would have an outdated PHP version. I've since replaced this with [`homebrew-php`](https://github.com/Homebrew/homebrew-php) specifically the package `php54`.

**Note:** If you've added some configurations in PHP which is most likely located at `/etc/php.ini`, you might want to copy the custom configurations over to your new PHP ini location which is `/usr/local/etc/php/5.4/php.ini` in my case. Also, PEAR needs to be reconfigured. `brew info php54` or `brew install php54` would note that you would need to invoke this commands to clean up PEAR configurations:

{{< highlight shell >}}
chmod -R ug+w /usr/local/Cellar/php54/5.4.38/lib/php
pear config-set php_ini /usr/local/etc/php/5.4/php.ini system
{{< / highlight >}}

I had an old installation of `PHP_CodeSniffer` and it got confusing when I tried to use `phpcs` since it was using the old sniffs rather than the ones that I recently updated.

### Code Sniffer

Installation of PHPCS is as easy as doing `composer global require "squizlabs/php_codesniffer=*"`.

### Coder

Installation of Coder is pretty much straightforward. Everything needed is [here](https://www.drupal.org/node/1419988). I've installed it using `drush`.

After installating Coder, you'll need to register the sniffs by invoking `phpcs --config-set installed_paths $HOME/.drush/coder/coder_sniffer`. Otherwise; you can do `phpcs --standard=path/to/sniffs/Drupal -- /path/to/file` to do the syntax check.

**Note:** PHPCS 1.x works with Coder 7.x-2.x while PHPCS 2.x works with Coder 8.x-2.x (source [here](https://www.drupal.org/node/2342611) and [here](https://www.drupal.org/node/2387871#comment-9409549)). I've installed Coder 8.x-2.x which also works with Drupal 7 modules.

There's a lot more you can do with PHPCS. One that I find useful is `phpcbf`. More usage examples [here](https://www.drupal.org/node/1587138).
