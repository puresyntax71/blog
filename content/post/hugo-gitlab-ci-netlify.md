---
title: "Deploy Hugo on Netlify using Gitlab Pipelines"
date: 2019-10-07T13:16:17+08:00
keywords: []
description: ""
tags: ['hugo', 'gitlab', 'netlify']
categories: ['development']
showtoc: false
resources:
    - title: Deploying a Vue.js app to Netlify using GitLab’s CI/CD pipeline
      url: https://medium.com/js-dojo/deploying-vue-js-to-netlify-using-gitlab-continuous-integration-pipeline-1529a2bbf170#405c
    - title: GitLab CI/CD Pipeline Configuration Reference
      url: https://docs.gitlab.com/ee/ci/yaml/
    - title: Hugo Gitlab Pages
      url: https://gitlab.com/pages/hugo
---

The current blog uses [Hugo](https://gohugo.io) as the static site generator with a forked theme of [Even](https://github.com/olOwOlo/hugo-theme-even). I've managed to use [Gitlab Pipelines](https://docs.gitlab.com/ee/ci/pipelines.html) to deploy the site to [Netlify](https://www.netlify.com).

The blog uses `git submodule` for its theme. This way, every time I make customizations on the theme, I can easily update the theme as part of the parent repository itself. The configuration for Gitlab Pipelines will all be in the `.gitlab-ci.yml` file.

In order for Gitlab to use submodules, the variable `GIT_SUBMODULE_STRATEGY` will need to be set.

```yaml
variables:
    GIT_SUBMODULE_STRATEGY: recursive
```

The default stage is `test` although I've defined 3 stages for the deployment:

1. **Setup**: Sets up the theme `even` --- installing the necessary `npm` packages using `yarn` and building the theme.
2. **Build**: Builds the actual hugo website with the output directory set to the default (`public`).
3. **Deploy**: Deploys the site to Netlify.

The stages run separately one after another. This can be defined in the `.gitlab-ci.yml` like so:

```yaml
stages:
    - setup
    - build
    - deploy
```

## Setup

My idea of a set up involves preparation of any files that would be needed to build the site. Currently, I only have building of the theme (since I've customized the theme) for this stage which would be just a single job.

The theme `even` uses `yarn` and `webpack` from the project's scripts to build the assets --- minified and updates a `json` file that points to the latest assets.

For this job, I only need to `cd` to the theme's directory, install the necessary `npm` packages, and build the assets. After building, I would need to pass over the built theme over to the next stage by using [artifacts](https://docs.gitlab.com/ee/user/project/pipelines/job_artifacts.html). I've also used the image `node:6.17.1` which is the version that works with the webpack package required by `even`.

The job for the `setup` stage looks like this:

```yaml
setup:
    image: node:6.17.1
    stage: setup
    before_script:
        - cd themes/even/
        - yarn install
    script:
        - yarn build
    artifacts:
        paths:
            - themes/even/
    only:
        - master
    cache:
        paths:
            - node_modules/
            - .yarn
```

The `cache` key allows speeding up the build process by preserving vendor packages. At this point, this isn't really necessary since it will not be reused in other jobs and/or stages.

## Build

The `build` stage is quite simple which involves a single job as well --- building the actual site. The command `hugo` with no parameters does this job.

The only considerations I had were using the extended version of `hugo` (in order to use SASS/SCSS with [Hugo Pipes](https://gohugo.io/hugo-pipes/)) and again, passing the artifact over to the next stage. I've also added the `setup` stage as a dependency.

So far, the job for the `build` stage looks like this:

```yaml
build:
    image: registry.gitlab.com/pages/hugo/hugo_extended:latest
    stage: build
    script:
        - hugo
    artifacts:
        paths:
            - public/
    only:
        - master
    dependencies:
        - setup
```

## Deploy

Deployment involves a single job as well. This is to only publish the 'public' directory to Netlify. The `netlify.toml` simply contains the configuration for the "Publish directory":

```toml
[build]
    publish = "public"
```

I've used variables to store the authentication token (`NETLIFY_AUTH_TOKEN`) and site ID (`NETLIFY_SITE_ID`) to deploy to Netlify using [Netlify CLI](https://cli.netlify.com). These variables are defined under "CI / CD Settings".

{{< figure src="/images/settings.png" title="CI / CD Settings" >}}

The steps involved in deployment are installing `netlify-cli` and deploying with `netlify-cli`. The job simply looks like this:

```yaml
deploy:
    image: node:latest
    stage: deploy
    before_script:
        - npm i -g netlify-cli
    script:
        - netlify deploy --site $NETLIFY_SITE_ID --auth $NETLIFY_AUTH_TOKEN --prod
    only:
        - master
    dependencies:
        - build
```

So far, these are the only steps involved when building the site. This is automatically triggered every time a push is made to the `master` branch. You then get a nice report of which stages failed and which ones succeeded.

{{< figure src="/images/pipelines.png" title="Pipelines" >}}

I've found this workflow very convenient for me. Netlify also supports [CD](https://www.netlify.com/docs/continuous-deployment/) although I find Gitlab Pipelines more flexible if I would ever need additional steps during deployment.
