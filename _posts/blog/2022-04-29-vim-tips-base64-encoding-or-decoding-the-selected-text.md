---
layout: post
title: 'vim tips: base64 encoding or decoding the selected text'
date: 2022-04-29 17:06 +0200
categories: [blog]
published: true
---

I've been writing a lot of these huge Kubernetes YAML files lately. Here's a
trick for Vim that has saved me a lot of time when editing secrets, which contain
base64 encoded values.

<!-- more -->

First, add the following lines to your `.vimrc`

```vim
vnoremap <leader>64d y:let @"=system('base64 -w 0 --decode', @")<cr>gvP
vnoremap <leader>64e y:let @"=system('base64 -w 0', @")<cr>gvP
```

This is a shortcut that, when you select a text and press `<leader>64e` or
`<leader>64d` copies the selected content in the unnamed register `@"`, replace
the register content with the encoded or decoded text, then paste the new text
inplace.

![]({{ "/assets/img/2022-04-29-vim-tips-base64-encoding-or-decoding-the-selected-text.svg" | relative_url }})

