## PHP 5.4 and PHPDBG in OS X

Got [PHPDBG](http://phpdbg.com/) enabled in PHP 5.4 although I've never bothered giving it a try. Recently, I decided to play around with it and try to compare it with Xdebug.

### Installation

I use [`homebrew-php`](https://github.com/Homebrew/homebrew-php) to install PHP 5.4. Versions 5.4+ have the flag `--with-phpdbg` if you wish to include PHPDBG during installation therefore installation is simply via invoking `brew install php54 --with-phpdbg`.
