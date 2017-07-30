+++
date = "2017-07-29T08:48:54+08:00"
draft = true
tags = ["tools", "commandline"]
title = "Zplug and Others"
categories = ["tools"]
+++
Been a user of [`prezto`][1] for about 5 years now (ever since I started using [`zsh`][2]) and have always wondered what's it's like to either have a minimal `zsh` configuration from scratch, to use a plugin manager, or try out another framework.

I went on ahead and checked out some `zsh` "tools" that I can migrate too. `zsh` from scratch is pretty hard for me and what I had in mind was that I don't change `zsh` configuration often.

## `zr`

I've stumbled on [`zr`][3] from [/r/zsh][4] which is a plugin manager written in [`rust`][5]. Installation was quite simple since all I had to do was clone the project and do a `cargo install `.

I installed some popular plugins and provided a basic `zsh` configuration. Everything was working fine. I then proceeded to installing some `prezto` modules (the `git` module was really useful to me).

For some reason, I then encountered a lot of errors. I'm not entirely sure what caused it. Maybe because `zr` is not mature enough yet, or perhaps I had errors in my configuration, or maybe I was missing some configurations. I didn't investigate further although I think I might just missing something.

## `zim`

[`zim`][6] is another `zsh` framework that marketed itself to be fast. I think it has something to do with `zcompile`. Its modules are also taken either from [`oh-my-zsh`][7] and/or `prezto`. Start up time does seem to be pretty fast.

Installation was really simple as well - similar to the installation of `prezto`. It provides a `custom` module which is meant for putting all user customizations.

One issue I had was that I can't get [`history-substring-search`][8] to work. I'm also a little uncomfortable when a project is outdated. `prezto` at one point became outdated which made me want to switch to another `zsh` framework. There are chances the same thing would happen to `zim`.

## `grml`

[`grmlzshconfig`][12] is a minimal `zsh` configuration and very popular on [Arch Linux][13]. It only has a `.zshrc` and customizations go on to `.zshrc.local`. It's really nice, simple, and fast and I've considered to switching to it as well.

## `zplug`

[`zplug`][9] is a popular plugin manager. It competes along side `antigen`.

I used `brew install zplug` (`brew info zplug` for more information) to install.

I installed a few plugins and realized that I really am dependent on `prezto`. I settled with `zplug` and `prezto` and installed the modules that I originally used in `prezto`. Still using `prezto` and not entirely sure what benefits have I gained with using `zplug` and `prezto` although it does feel neater now having lines like these only:

{{< highlight bash >}}
zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
{{< / highlight >}}

I might move to other [`zsh` tools][10] (maybe [zgen][11]) in the near future but for now I'm fine with `zplug` and `prezto`.

[1]: https://github.com/sorin-ionescu/prezto
[2]: http://zsh.sourceforge.net/
[3]: https://github.com/jedahan/zr
[4]: https://reddit.com/r/zsh
[5]: https://www.rust-lang.org/en-US/
[6]: https://github.com/Eriner/zim
[7]: https://github.com/robbyrussell/oh-my-zsh
[8]: https://github.com/Eriner/zim/issues/197
[9]: https://github.com/zplug/zplug
[10]: https://github.com/unixorn/awesome-zsh-plugins
[11]: https://github.com/tarjoilija/zgen
[12]: https://grml.org/zsh/
[13]: https://archlinux.org
