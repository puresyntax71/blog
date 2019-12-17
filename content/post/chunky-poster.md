---
title: "New Theme: Chunky Poster"
date: 2019-12-18T00:35:50+08:00
images: ["/images/web-design.jpeg"]
categories: []
tags: ["hugo", "blog"]
authors: ["Strict Panda"]
---

I've recently published the theme [Chunky Poster](https://gitlab.com/virtualcursor/hugo-theme-chunky-poster). Been working on the theme for a few nights now and finally got the basics down. I've also updated my blog to use the theme. The demo can be found [here](https://hugo-theme-chunky-poster.netlify.com/).

{{< figure src="https://gitlab.com/virtualcursor/hugo-theme-chunky-poster/raw/master/images/screenshot-responsive.png" title="Chunky Poster" >}}

The theme uses [Bootstrap 4](https://getbootstrap.com/docs/4.4/getting-started/introduction/) and is based on the [Prisma blog](https://www.prisma.io/blog/).

## Features

### Multi-author

The multi-author feature is based on this [blog post](https://www.netlify.com/blog/2018/07/24/hugo-tips-how-to-create-author-pages/). It uses taxonomy for the authors and has a layout defined for the list of content for the author. An example is [this](https://hugo-theme-chunky-poster.netlify.com/authors/hugo-authors/) which is found on the demo site.

### Image Processing

It utilizes [image processing](https://gohugo.io/content-management/image-processing/) to process the appropriate image sizes for the card layout and cover image.

### Basic i18n

It has basic multilingual support although there isn't much [translation for strings](https://gitlab.com/virtualcursor/hugo-theme-chunky-poster/blob/master/i18n/en.yaml).

### Syntax Highlighting

Most Hugo themes use [Highlight.js](https://highlightjs.org/) for syntax highlighting as the javascript library. The theme uses [Prism](https://prismjs.com/) instead. The library also supports [various languages](https://prismjs.com/#supported-languages).

### LazyLoad

There seem to be a lot of websites nowadays using lazy loading that utilizes [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API) to load images. I found the library [lazyload](https://github.com/verlok/lazyload) and included it on the theme to lazy load the cover images.

{{< figure src="/images/lazyload.gif" title="Lazyload" >}}

### Comment System

I've been using a self-hosted [Commento](https://commento.io/) that I have added on the previous theme of the blog. I've added basic support for this on the post content pages.

## Development

Development uses [`webpack`](https://webpack.js.org/).

For customizations, you can do `yarn watch` and make the necessary changes for `webpack` to update the manifest found at `data/chunky-poster/assets.json`.

As for the production build, after finalizing the changes, there is a need to do `yarn build` so that the manifest will point to the production build files.

I've used [dynamic imports](https://webpack.js.org/api/module-methods/#import-1) during development which utilizes [code splitting](https://webpack.js.org/guides/code-splitting/#dynamic-imports) to generate the files although I've had trouble with this in production which seems to be a [common](https://github.com/jantimon/html-webpack-plugin/issues/927) [issue](https://github.com/webpack/webpack/issues/5588). It suggests using `publicPath` although I need to be able to set it dynamically. I ended up disabling [chunks](https://medium.com/@glennreyes/how-to-disable-code-splitting-in-webpack-1c0b1754a3c5) in production instead.

## Future

I think there still needs a lot of fixing and support for other basic features of Hugo although I am quite satisfied with its current status. I will be continuously updating the theme to include these changes.

I am also planning to add other features later on.
