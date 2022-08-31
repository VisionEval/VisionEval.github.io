## Website management

This website is built with the '[Hydeout](https://github.com/fongandrew/hydeout)' theme for GitHub pages. It uses Jekyll, a tool built in Ruby to generate web pages from content written in Markdown, and is integrated with GitHub.

There are three options for making updates to this website:

1. Editing files directly on GitHub -- not recommended, but possible.
2. Clone the repository, make changes with a text editor, and push commits back to master. You will only see the outcome of your changes after pushing your commits.
3. Recommended approach: clone the repository, make changes with a text editor, preview those changes locally using Jekyll (see below), then push when satisfied with the changes.

The third approach is detailed here:
 - Windows machines need to download and install [Ruby](https://rubyinstaller.org/downloads/)
 - Open a Unix or Unix-like command-line utility (Terminal on Mac, [Git BASH](http://gitforwindows.org/) on Windows will work)
 - Install Jekyll with `gem install jekyll`. See details [here](https://jekyllrb.com/docs/installation)
 - Install bundler with `gem install bundler`. This Ruby tool updates all needed Ruby dependencies.
 - Clone this repository to your machine, navigate to it (e.g., `cd ~/<pathtorepos>/VisionEval.org`), and run `bundle install`.
 - Now you can make edits to the contents. In combination with the `serve` command below, you can preview the changes live before pushing to the repository. The first time you do this, you'll need to build the rendered pages with:

```
bundle exec jekyll build
```

Then, to preview the edits live as you go, run the following:

```
bundle exec jekyll serve
```

If you have already built the pages once before, simply run the `serve` command to preview changes live. These are essentially the same steps that GitHub takes when generating a `gh-pages` page from a repository, and let you preview the rendered site as you make changes on the fly. Then you can push the completed batch of edits all at once.

Example instructions from another open-source project are here:
https://github.com/stan-dev/stan-dev.github.io/wiki/Using-the-Jeykll-Based-Website

Maintain the Ruby Gems with `bundle update`.

## VisionEval

The working version of the VisionEval project is currently [here](https://github.com/visioneval/VisionEval).

### What is VisionEval?

See the overview of VisionEval [here](https://VisionEval.org/)
