---
layout: page
title: Information for users
excerpt: "An collection of resources for VisionEval users."
image:
  feature: so-simple-sample-image-4-narrow.jpg
search_omit: true
---

<ul class="post-list">
{% for post in site.categories.users %} 
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
