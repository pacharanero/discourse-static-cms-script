# Discourse Static CMS helper script

This Ruby script allows you to use Discourse as a simple CMS for static site page content in Markdown. It's a work in progress at the moment. I wrote it because I found myself wishing for a slightly nicer editing environment for my Markdown when building static sites.

Initially this was built for Jekyll, but there's no reason it wouldn't work with many other static site generators such as Hugo and Gatsby, etc.

## How it works

You tell the script which raw markdown pages you want it to pull and it will go there and get them, saving them in files locally

A nice thing is that, although it *will* overwrite old files with new content if the content has changed on the Discourse, you still have Git version control over the static pages, so you can roll back to previous versions and do anything that you would want to do with Git.

It doesn't have to be a Discourse instance, for the record - any page (eg a Git README.md or a Gist) which can be accessed in a `raw` form and pulled by the script into a file, will work.

## Roadmap

* Handling Discourse API keys for private page content (will be in ENV vars probably)