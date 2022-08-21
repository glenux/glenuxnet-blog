---
layout: post
title: The sha256 fingerprint of a SSH public key
date: 2022-08-20 09:00:15
categories: []
tags:   []
published: true
---

Recently, a company in which I was involved in training did not really have the
right technical environment to carry out the said training with its employees.

I usually work with virtual machines, or with VPS created on demand and
accessible via SSH. But there was no virtualization and all destination ports
were blocked. Only HTTPS was left (but filtered).

<!-- more -->

I didn't want to explain to the trainees how to pass an SSH stream via an HTTPS
proxy, even if it can be done with corkscrew. So I used SSHwifty which is
specifically designed to provide a terminal and an SSH connection (like the
venerable Putty), but via the web.

SSHWifty fonctionne comme une passerelle, qui va donner accès à différentes
machines. Par défaut on peut tout à fait l'utiliser pour se connecter à des
machines qui n'ont rien à voir.

(schema de l'infrastructure)

Dans mon cas, j'installais un SSHWifty avec une configuration verouillée pour
chaque utilisateur.




SSHWifty demande évidemment de vérifier la clef ssh

Two ways to get the sha256 of an SSH key

1. Either use ssh-keygen
2. Or use the DNS SSHFP output

See <https://fr.wikipedia.org/wiki/Enregistrement_DNS_SSHFP> for details

    $ ssh-keyscan -D -t rsa HOSTNAME | sed -n 's/.* SSHFP . 2 //p'

or from keyscap + keygen reformating

    $ ssh-keyscan -t rsa HOSTNAME | ssh-keygen -l -E sha256 -f - | cut -f2 -d' '

