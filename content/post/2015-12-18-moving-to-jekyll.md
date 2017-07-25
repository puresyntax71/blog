---
categories: jekyll
date: 2015-12-18T00:00:00Z
title: Moving to Jekyll
tags: []
---

Finally moved back to jekyll. Nothing fancy here though. This is hosted again in Github Pages.

I've made some small modifications on the default template and added the [`jekyll-archives`](https://github.com/jekyll/jekyll-archives) plugin. I might add some additional plugins and/or modifications (disqus comments). Everything is based on [jekyll's documentation][1]. Here are a few things that might be worth noting though:

## Bundler

It comes with a `Gemfile`. Executing `bundle install` or simply `bundle` will install the dependencies that came with the installation. Also I think it's recommended to prefix commands with `bundle exec` (e.g. `bundle exec jekyll serve`).

## Ruby Version

The ruby version is specified in the `.ruby-version` file which makes it friendly with popular ruby version managers.

## Continuous Integration

The documentation for jekyll includes [Travis CI][2]. It makes use of the [`html-proofer`][3] gem to check your built HTML files.

## Automated Deployment

The documentation for jekyll also includes [automated deployment][4] for Github Pages but with a gem called [kickster][5]. I didn't install the gem but rather just copied its deployment scripts for [Travis CI][6].

[1]: http://jekyllrb.com/docs/home/
[2]: http://jekyllrb.com/docs/continuous-integration/
[3]: https://github.com/gjtorikian/html-proofer
[4]: http://jekyllrb.com/docs/deployment-methods/#kickster
[5]: http://kickster.nielsenramon.com/
[6]: https://github.com/nielsenramon/kickster/tree/master/snippets/travis
