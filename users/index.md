---
layout: page
title: Information for users
excerpt: "An collection of resources for VisionEval users."
image:
  feature: so-simple-sample-image-4-narrow.jpg
search_omit: true
---

The work to date by the founding FHWA-Oregon DOT partnership has focused on the technical components of establishing the common programming framework so that enhancements made in one model can be readily transferred to other models. Modules in the VisionEval common framework will work in consistent geographic scales so modules built for one will be usable in the others.  This common geography can either be directly input or synthesized. Efforts are also underway to build a supportive community around the tool, drawing from successful past and interested future users nationally, who will both define the policy needs and uses of these tools, and set their direction moving forward. A forum is envisioned to help partners share best practices in the application of these tools. The VisionEval framework is based on the following models.

<ul class="post-list">
{% for post in site.categories.users %} 
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
