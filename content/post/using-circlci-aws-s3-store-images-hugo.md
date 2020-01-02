---
title: "Using Circle CI and AWS S3 to Store Images in Hugo"
date: 2020-01-02T13:33:42+08:00
images: ["/images/photo-album.jpg"]
categories: []
tags: ["hugo", "blog"]
authors: ["Strict Panda"]
---

Considering now that the blog has cover images to adhere with the design of the [theme]({{< relref "chunky-poster.md" >}}) (also with the old [theme](https://github.com/zhaohuabing/hugo-theme-cleanwhite)), the number of images are getting larger including the repository itself. I've since removed the images from the repository and stored them on AWS S3.

The idea behind is to sync the images from the local filesystem to a bucket in S3, copy the files from the bucket over to a Circle CI workspace which contains the build files of Hugo, and finally deploy the build files to Netlify.

## Sync'ing the Images

I've created first a bucket on S3 to store the images for the blog. In order to sync the images from the local filesystem, I have installed and configured [AWS CLI](https://aws.amazon.com/cli/):

```shell
$ brew install awscli
$ aws configure
```

Configuration is pretty much straightforward. I think all I needed to do was set the API keys and the region to where to store the images from. Permission was a bit confusing as I haven't used AWS much although I've set it to private since its purpose is only to store the images --- Netlify will be the one actually hosting the images.

After configuring, I've used `aws sync` to sync the files from local filesystem to the bucket:

```shell
$ aws s3 sync . s3://path-to-bucket/
```

## Copy Files Using Circle CI on Deployment

I've used the orb [`aws-s3`](https://circleci.com/orbs/registry/orb/circleci/aws-s3) for Circle CI and added a job `images` to do the execution. The files are then persisted to a workspace. The `build` job is the one responsible for building Hugo and so I've attached the workspace over to this job and finally copied the files over to "content/images". The `images` job is also a dependency for the `build` job.

```yaml
orbs:
  # The rest of the orbs.
  hugo: circleci/hugo@0
  aws-s3: circleci/aws-s3@1
version: 2.1

jobs:
  images:
    docker:
      - image: circleci/python:2.7
    steps:
      - aws-s3/copy:
          from: 's3://path-to-bucket'
          to: images
          arguments: --recursive
      - persist_to_workspace:
          root: .
          paths:
            - images
  build:
    docker:
      - image: cibuilds/hugo:latest
    steps:
      - attach_workspace:
          at: ~/images
      - checkout
      - run: cp -r ~/images/images/* content/images
    # The rest of the steps.
workflows:
  main:
    jobs:
      - images
      - build:
          requires:
            - images
      # The rest of the jobs.
```

The required environment variables to configure the `aws-s3` orb are the following:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`

These can be configured through Circle CI under Project Settings >> Build Settings >> Environment Variables.

{{< figure src="/images/project-settings.png" title="Project Settings" >}}

So far, that is it. I just removed the images from the repository and added a `.gitignore` file to ignore the images under "content/images".

I still need to include the static images though but will probably do it sometime in the future.
