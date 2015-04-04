## PHP, Coder, Code Sniffer, and Syntastic in OS X

I originally used the PHP package bundled with OS X. This doesn't seem to be easily maintainable since you would have an outdated PHP version. I've since replaced this with [`homebrew-php`](https://github.com/Homebrew/homebrew-php) specifically the package `php54`.

**Note:** If you've added some configurations in PHP which is most likely located at `/etc/php.ini`, you might want to copy the custom configurations over to your new PHP ini location which is `/usr/local/etc/php/5.4/php.ini` in my case. Also, PEAR needs to be reconfigured. `brew info php54` or `brew install php54` would note that you would need to invoke this commands to clean up PEAR configurations:

```shell
chmod -R ug+w /usr/local/Cellar/php54/5.4.38/lib/php
pear config-set php_ini /usr/local/etc/php/5.4/php.ini system
```
