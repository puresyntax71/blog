## PHP 5.4 and PHPDBG in OS X

Got [PHPDBG](http://phpdbg.com/) enabled in PHP 5.4 although I've never bothered giving it a try. Recently, I decided to play around with it and try to compare it with Xdebug.

### Installation

I use [`homebrew-php`](https://github.com/Homebrew/homebrew-php) to install PHP 5.4. Versions 5.4+ have the flag `--with-phpdbg` if you wish to include PHPDBG during installation therefore installation is simply via invoking `brew install php54 --with-phpdbg`.

The version of PHPDBG that comes with the `php54` package is `v0.3.2`. I gave this a try but didn't much like it as it had a lot of bugs. What worked for me was replacing it with the one with latest changes (specifically c6802cdf). It still had a few bugs in it but it was way better. I had to change the source of `homebrew-php` to make it work. Here's a diff of my changes at `homebrew-php` installation directory:

```diff
diff --git a/Abstract/abstract-php-version.rb b/Abstract/abstract-php-version.rb
index 943b259..9b7dee8 100644
--- a/Abstract/abstract-php-version.rb
+++ b/Abstract/abstract-php-version.rb
@@ -1,10 +1,10 @@
 class AbstractPhpVersion < Formula
   module PhpdbgDefs
-    PHPDBG_SRC_TARBAL = 'https://github.com/krakjoe/phpdbg/archive/v0.3.2.tar.gz'
+    PHPDBG_SRC_TARBAL = 'https://github.com/krakjoe/phpdbg/archive/master.tar.gz'
     PHPDBG_CHECKSUM   = {
-                        :md5    => '84255abff00fb31e338d03564c3cc4e4',
-                        :sha1   => 'c57174ab235ec69997e1a37e6d2afe3e4edfb749',
-                        :sha256 => 'feab6e29ef9a490aa53332fe014e8026d89d970acc5105f37330b2f31e711bbd',
+                        :md5    => '5a9346fe533fc486e2427cb0517b7159',
+                        :sha1   => '25e53a5ff1c66afd8c34a98404d5242e61b4d55b',
+                        :sha256 => '06eb09e5cb5deac4812a0ed7305e9d640f1ec6b6fbfdc6ea9a24bf7ea9d01929',
                       }
   end
 
```
