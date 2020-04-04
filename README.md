# Blog

![CircleCI](https://img.shields.io/circleci/build/github/puresyntax71/blog)

Install and configure [`awscli`](https://aws.amazon.com/cli/).

```bash
$ git clone --recurse-submodules git@github.com:puresyntax71/blog.git
$ aws s3 sync s3://bucket/ content/images/
```

## Sync files

```bash
$ aws s3 sync content/images/ s3://bucket/ --exclude ".gitignore" --exclude "index.md" --delete
```

## Resize images

```bash
$ convert content/images/<image.jpg> -resize "1920x1200^" -gravity center -extent 1920x1200 content/images/<image.jpg>
```
