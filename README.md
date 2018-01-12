## Website management

This website is built with the '[So Simple](https://github.com/mmistakes/so-simple-theme)' theme for GitHub pages. It uses Jekyll, a tool built in Ruby to generate web pages from content written in Markdown, and is integrated with GitHub.

There are three options for making updates to this website:

1. Editing files directly on GitHub -- not recommended, but possible.
2. Clone the repository, make changes with a text editor, and push commits back to master. You will only see the outcome of your changes after pushing your commits.
3. Recommended approach: clone the repository, make changes with a text editor, preview those changes using Jekyll (see below), then push when satisfied with the changes. 

The third approach is detailed here:
 - Windows machines need to download and install [Ruby](https://rubyinstaller.org/downloads/)
 - Open a Unix or Unix-like command-line utility (Terminal on Mac, [Git BASH](http://gitforwindows.org/) on Windows will work)
 - Install Jekyll with `gem install jekyll`. See details [here](https://jekyllrb.com/docs/installation)
 - Install bundler with `gem install bundler`. This Ruby tool updates all needed Ruby dependencies.
 - Clone this repository to your machine, navigate to it, and `bundle install`.
 - Now you can make edits to the contents. After doing so, you can preview the changes before pushing to the repository with:

```
bundle exec jekyll build
bundle exec jekyll serve
```
These are essentially the same steps that GitHub takes when generating a `gh-pages` page from a repository, and let you see the rendered site as you make changes on the fly.
  
Example instructions from another open-source project are here:
https://github.com/stan-dev/stan-dev.github.io/wiki/Using-the-Jeykll-Based-Website



## VisionEval

The working version of the VisionEval project is currently [here](https://github.com/visioneval/VisionEval).

### What is VisionEval?

See the overview of VisionEval [here](http://VisionEval.org/)

