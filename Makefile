all: resume build

build:
	bundle exec jekyll build

resume:
	resume export --theme short resume.html
