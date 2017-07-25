---
categories: tools
date: 2015-12-19T00:00:00Z
tags: ["tools", "osx", "commandline"]
title: Password Management using Password Store
---

[Password Store][1] is a command line utility for managing your passwords. The passwords are stored in an encrypted file which makes use of `gpg`. It also allows you to use `git` to track password changes.

`pass` isn't as feature-rich compared to [Last Pass](https://lastpass.com/) or [1Password](https://agilebits.com/onepassword) though.

## Setup

Setup is pretty easy. It only requires `gpg` which can be installed via `brew`. Optionally, you can install `git` if you want to track changes in your storage.

{{< highlight shell >}}
$ brew install gpg pass
{{< / highlight >}}

### GPG (skip if you already have a key)
You would need to set up your gpg key if you don't have one.

{{< highlight shell >}}
$ gpg --gen-key
{{< / highlight >}}

You will then be presented with this prompt:

{{< highlight shell >}}
$ gpg --gen-key
gpg (GnuPG) 1.4.19; Copyright (C) 2015 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection?
{{< / highlight >}}

Select the default (RSA and RSA). The other steps will depend on how you want your key to be set up.

### Pass

Initialize `pass`:

{{< highlight shell >}}
$ pass init
{{< / highlight >}}

This will create a directory in your `$HOME` called `.password-store`.

## Usage

`pass help` provides a list of all available commands so I'll probably just list here the basics. `pass` simply lists all your stored passwords.

### Inserting

`pass` treats `/` similar to subfolders. An example is this:

{{< highlight shell >}}
$ pass
Password Store
├── foo
│   └── bar.gpg
│   └── baz.gpg
└── bar
    └── foo.gpg
{{< / highlight >}}

This can be accomplished by invoking the commands:

{{< highlight shell >}}
$ pass insert foo/bar
Enter password for foo/bar:
Retype password for foo/bar:
$ pass insert foo/baz
Enter password for foo/baz:
Retype password for foo/baz:
$ pass insert bar/foo
Enter password for bar/foo:
Retype password for bar/foo:
{{< / highlight >}}

### Editing

Editing is similar to inserting.

{{< highlight shell >}}
$ pass edit foo/bar
{{< / highlight >}}

You will then be asked to enter your password for your key. This will open up your default editor where you can modify your password.

### Reading

This is similar to editing in which `pass` would open up a prompt which asks your password for your key.

To display your password, invoke this command:

{{< highlight shell >}}
$ pass foo/bar
{{< / highlight >}}

To copy your password in the clipboard, just add the `-c` flag. `pass` removes it from the clipboard after 45 seconds.

## Storage

`pass` supports `git`. Depending on how you want it stored, you can either track it on Github or some other service. A few posts in SO say that it's fine to store them [on][2] [github][3].

A quick rundown on using `pass` with `git`:

{{< highlight shell >}}
$ pass git remote add <alias> <remote>
$ pass git push
{{< / highlight >}}

Everytime you insert, modify, or delete a password, `pass` issues a commit.

[1]: http://www.passwordstore.org/
[2]: http://superuser.com/questions/981297/is-it-safe-to-store-encrypted-passwords-on-github
[3]: http://stackoverflow.com/questions/8839141/is-it-considered-good-practice-to-store-passwords-in-a-private-github-repository
