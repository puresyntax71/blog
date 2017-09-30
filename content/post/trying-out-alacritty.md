+++
tags = ["osx", "tools"]
title = "Trying Out Alacritty"
date = "2017-07-26T07:59:39+08:00"
categories = [
  "tools"
]
+++

Recently stumbled on this [comment][1] from [lobste.rs][2]. I have heard of [Alacritty][3] before but never had a chance to try it out. This time I have decided to at least check it out.

## What is Alacritty?

**Alacritty** claims to be a really fast terminal emulator. It has a unique feature according to its description:

> Alacritty is the fastest terminal emulator in existence. Using the GPU for rendering enables optimizations that simply aren't possible in other emulators.

I used to use [`rxvt-unicode`][4] back in [Arch Linux][5] and have found it to be very fast considering its small amount of features (which seems to be another advantage of **Alacritty**). I then switched to [iTerm2][6] when I moved to MacOS.

## Installation of Alacritty

Installation is very simple. All I needed to do was install **Rust** using [rustup][7], clone the [repository][3] (first few steps can also be found [here][9]), and follow the link [here][8]. I always forget about Github's wiki and missed the documentation about "MacOS application bundle". I originally did a `cp target/release/alacritty /usr/local/bin` before finding the wiki.

After installation the configuration can be found at `$HOME/.config/alacritty/alacritty.yml` (one of the paths where **Alacritty** searches for the configuration).

## Issues/Missing Features

I really like **Alacritty** and while it is fast, it does still need some features and fixes. It sacrificed features over speed. While I like that it has lesser features compared to most terminal emulators, it may have went beyond in leaving its features behind. One comment from [/r/programming][10] says this:

<div class="reddit-embed" data-embed-media="www.redditmedia.com" data-embed-parent="false" data-embed-live="false" data-embed-uuid="2a03260a-6e92-4c3c-885b-03b739087f94" data-embed-created="2017-09-16T16:49:21.841Z"><a href="https://www.reddit.com/r/programming/comments/5mflek/alacritty_a_gpuaccelerated_terminal_emulator/dc3r3zc/">Comment</a> from discussion <a href="https://www.reddit.com/r/programming/comments/5mflek/alacritty_a_gpuaccelerated_terminal_emulator/">Alacritty, a GPU-accelerated terminal emulator written in Rust</a>.</div><script async src="https://www.redditstatic.com/comment-embed.js"></script>

Here are some features that I find might be useful for me and luckily there are already issues on Github to implement these features (these are also MacOS specific):

1. [Support for Alt+key][11]

    I use `emacs` mode in my shell and commonly use combinations such as <kbd>alt</kbd> + <kbd>b</kbd> (to move a word back) or <kbd>alt</kbd> + <kbd>.</kbd> (to insert last argument from previous command). [iTerm2][6] has an option to have the "Left option" key act as "+esc". Can't entirely remember what "+esc" is although it allows me to use the same key combinations similar to Linux with the <kbd>alt</kbd> key.

    **Alacritty** doesn't have this (yet) although a workaround is to specify the combinations and provide the characters it would "invoke". An example for <kbd>alt</kbd> + <kbd>b</kbd> and <kbd>alt</kbd> + <kbd>f</kbd> would be these:

    {{< highlight yaml >}}
    - { key: B,        mods: Alt,     chars: "\x1bb"                       }
    - { key: F,        mods: Alt,     chars: "\x1bf"                       }
    {{< / highlight >}}

2. [Proper full screen support][12]

    Currently, **Alacritty** doesn't have support for full screen. For iTerm2 specifically, it has support for non-native full screen in MacOS. This occupies the whole screen and sits on top of the other applications (unlike the green expand button which seems to occupy a whole other space).

3. [Support multiple windows][13]

    Currently when running the MacOS application bundle through either spotlight or Alfred, only a single instance of **Alacritty** is allowed. I usually run `tmux` and `vim` in separate windows (or tabs in iTerm2). It would be nice if **Alacritty** supports this.

4. [URL recognition][14]

    It's a bit difficult to open links from **Alacritty**. In iTerm2, you could do a combination of <kbd>alt</kbd> + <kbd>command</kbd> + mouse left click to open a link in the default browser. Back in `rxvt-unicode`, Arch Linux has a documentation on having [Clickable URLs][15].

While **Alacritty** is still in its early version:

> The software is considered to be at an alpha level of readiness--there are missing features and bugs to be fixed, but it is already used by many as a daily driver.

I'm still happy that these features are planned to be implemented. I haven't used **Alacritty** really long yet. I might go back to iTerm2 but for now I will probably still be using **Alacritty**. The missing features I can live without.

[1]: https://lobste.rs/s/xvwozt/terminal_shell_performance#c_yvgwoo
[2]: http://lobste.rs/
[3]: https://github.com/jwilm/alacritty
[4]: http://software.schmorp.de/pkg/rxvt-unicode.html
[5]: http://archlinux.org/
[6]: https://www.iterm2.com/
[7]: https://www.iterm2.com/
[8]: https://github.com/jwilm/alacritty/wiki/MacOS-application-bundle
[9]: https://github.com/jwilm/alacritty#prerequisites
[10]: https://www.reddit.com/r/programming/comments/5mflek/alacritty_a_gpuaccelerated_terminal_emulator/dc3r3zc/
[11]: https://github.com/jwilm/alacritty/issues/93
[12]: https://github.com/jwilm/alacritty/issues/34
[13]: https://github.com/jwilm/alacritty/issues/607
[14]: https://github.com/jwilm/alacritty/issues/113
[15]: https://wiki.archlinux.org/index.php/rxvt-unicode#Clickable_URLs
