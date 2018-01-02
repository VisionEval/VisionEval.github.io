---
layout: page
title: Information for Developers
excerpt: "A collection of resources for VisionEval developers."
image:
  feature: so-simple-sample-image-4-narrow.jpg
search_omit: true
---


See the VisionEval [**wiki**](https://github.com/visioneval/VisionEval/wiki) on GitHub for the following resources:

- [Getting Started](https://github.com/VisionEval/VisionEval/wiki/Getting-Started)
- [Developer Orientation](https://github.com/VisionEval/VisionEval/wiki/Developer-Orientation)
- [Automated Testing](https://github.com/VisionEval/VisionEval/wiki/Automated-Testing)
- [Modules and Packages](https://github.com/VisionEval/VisionEval/wiki/Modules-and-Packages)
- [Development Roadmap](https://github.com/VisionEval/VisionEval/wiki/Development-Roadmap)

<ul class="post-list">
{% for post in site.categories.developers %} 
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
