---
layout: category
title: Information for Developers
excerpt: "A collection of resources for VisionEval developers."
search_omit: true
---


See the VisionEval <a href="https://github.com/visioneval/VisionEval/wiki" target="_blank"><b>wiki</b></a> on GitHub for the following resources:

- <a href="https://github.com/VisionEval/VisionEval/wiki/Getting-Started" target="_blank">Getting Started</a>
- <a href="https://github.com/VisionEval/VisionEval/wiki/Developer-Orientation" target="_blank">Developer Orientation</a>
- <a href="https://github.com/VisionEval/VisionEval/wiki/Automated-Testing" target="_blank">Automated Testing</a>
- <a href="https://github.com/VisionEval/VisionEval/wiki/Modules-and-Packages" target="_blank">Modules and Packages</a>
- <a href="https://github.com/VisionEval/VisionEval/wiki/Development-Roadmap" target="_blank">Development Roadmap</a>

<a href="http://www.github.com/visioneval/visioneval" target="_blank"><b>VisionEval GitHub Repository</b></a> 

<ul class="post-list">
{% for post in site.categories.developers %} 
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
