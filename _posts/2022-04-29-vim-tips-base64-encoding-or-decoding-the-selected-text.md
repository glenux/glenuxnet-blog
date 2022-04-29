---
layout: post
title: 'vim tips: base64 encoding or decoding the selected text'
date: 2022-04-29 17:06 +0200
---

I've been writing a lot of these huge Kubernetes YAML files lately. Here's a
trick that has saved me a lot of time when editing secrets, which contain
base64 encoded values.

First, add the following lines to your `.vimrc`

```vim
vnoremap <leader>64d y:let @"=system('base64 -w 0 --decode', @")<cr>gvP
vnoremap <leader>64e y:let @"=system('base64 -w 0', @")<cr>gvP
```

It is a shortcut to that copies the selected content in the buffer, replace the
buffer with the encoded or decoded version, then paste the new text inplace.

![](../../assets/img/2022-04-29-vim-tips-base64-encoding-or-decoding-the-selected-text.svg)

