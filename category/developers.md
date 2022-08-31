---
layout: category
title: Information for Developers
excerpt: "A collection of resources for VisionEval developers."
search_omit: true
---

See the VisionEval <a href="https://visioneval.org/docs/index.html" target="_blank"><b>Docs</b></a> for the following resources:

- <a href="https://visioneval.org/docs/getting-started.html#getting-started" target="_blank">Getting Started</a>
- <a href="https://visioneval.org/docs/index.html#developer" target="_blank">Developer Orientation</a>
- <a href="https://visioneval.org/docs/software-framework.html" target="_blank">Software Framework</a>

# VisionEval Repositories

There are three repositories to serve different purposes:
 - **[VisionEval](https://github.com/VisionEval/VisionEval)**: Public release version of VisionEval. There is one master branch only. This wiki is associated with the VisionEval repository. If you have a bug report or other issue, create an issue instead in the VisionEval-Dev repository ([here](https://github.com/VisionEval/VisionEval-Dev/issues)).

 - **[VisionEval-Dev](https://github.com/VisionEval/VisionEval-Dev)**: Main repository for developers and power-users who want to contribute code improvements. There are multiple branches, including `master` (which is can be considered the beta release) and `development` where active code development happens. Additional branches can be used to evaluate new features or pull requests. Developers / power-users should [create issues](https://github.com/VisionEval/VisionEval-Dev/issues) and [pull requests](https://github.com/VisionEval/VisionEval-Dev/pulls) to this repository.

 - **[VisionEval.org](https://github.com/VisionEval/VisionEval.org)**: Website repository. You can [create issues](https://github.com/VisionEval/VisionEval.org/issues) here for website-related change requests.

See the [Repository Structure document](https://github.com/VisionEval/VisionEval/wiki/Repository-Structure) on the VisionEval wiki for more details.


<ul class="post-list">
{% for post in site.categories.developers %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
