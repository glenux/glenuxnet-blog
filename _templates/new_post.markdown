---
layout: <%= @layout %>
title: "<%= @title %>"
date: <%= Time.now.strftime("%Y-%m-%d %H:%M") %>
categories: <%= Array(@categories) %>
tags: <%= Array(@tags) %>
source: "<%= @url %>"
---
