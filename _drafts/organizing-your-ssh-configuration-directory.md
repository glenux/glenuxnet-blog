---
layout: post
title: A successful SSH configuration model
---

Well, I've been using Unix systems and playing with networks for almost 25 years. Since I abandoned the venerable _rsh_ and _telnet_ in favor of SSH, I've gradually accumulated keys and configuration to access many projects, services and servers.

At first I stored all the keys directly in the `~/.ssh/` folder and all the configuration in `~/.ssh/config`, but obviously this didn't last very long. With the profusion of keys and configurations, many recurring questions started to bother me.

It started with the keys. Which key corresponded to what? For which server? For which user? At what time? Should we still use this key? Is it not obsolete? etc.

And then on the configuration side too! How to keep the configuration "clean"? How to avoid duplicate configurations? How to avoid the risk of losing everything in case of wrong manipulation?

Of course, [it is very strongly recommended to use SSH certificates](https://smallstep.com/blog/use-ssh-certificates/) rather than SSH keys to avoid most of these questions. However, even if you do things correctly on the information system you manage, you will often need silly asymmetric keys because the majority of online services do not accept SSH certificates at the moment, so you have to manage and organize all these files.

#### Divide and conquer

After many unsuccessful attempts, I arrived at the following structure for the contents of the `~/.ssh/` folder:

* *One `keyring.XXXX` folder per topic*, per online service or per organization, which is stored in `~/.ssh`.
  
  * Ex: `.ssh/keyring.mycompany`

* * Ex: `.ssh/keyring.myclient`
  
  * Ex: `.ssh/keyring.gitlab`
  
  * Ex: `.ssh/keyring.vagrant`

* The key pairs of a topic, service or organization are stored in the folder named after it.
  
  * Ex: `~/.ssh/keyring.mycompany/key` et `~/.ssh/keyring.mycompany/key.pub`.

* The key pairs of a topic, service or organization are stored in the folder named after it :
  
  * Ex: `~/.ssh/keyring.mycompany/config`.



Here's the big picture:

```
~/.ssh/
  |- keyring.mycompany/
  |    |- key1
  |    |- key1.pub
  |    |- key2
  |    |- key2.pub
  |    |- ...
  |    `- config
  |- keyring.myclient/
  |    |- key3
  |    |- key3.pub
  |    |- ...
  |    `- config
  |- keyring.gitlab/
  |    |- ...
  |    `- config
  |- ...
  |- authorized_keys
  |- known_hosts
  `- config
```

I'm tempted to tell you that it all works pretty well, but that probably wouldn't be enough. So let me explain why and how it works. 

#### Name your keys to find them

Obviously, I don't call my keys `key1` or `key2`. I use a _naming scheme_, i.e. an invariable and semantically representative pattern, to name my SSH keys depending on their purpose.

I use the following structure:

```
SrcUser@SrcHost,Action,DstUser@DstHost,Details,Cypher
```

Voyons le contenu de chacun des morceaux:

* `srcuser`: le nom d'utilisateur sur la machine source (ex: jsnow)
* `srchost`: le hostname (court) de la machine source (ex: winterfell)
* `action`: le type d'action prévue pour cette clef (shell, gitpush, deploy, ...)
* `dstuser`: le nom d'utilisateur sur la machine distante (ex: jonny)
* `dsthost`: le hostname ou le nom de service distant (ex: github.com, gitlab.com, example.com)
* `details`: des informations utiles, comme l'année de création ou l'absence de mot de passe (ex: pass.2022, nopass.2022)
* `cypher`: le type de cypher utilisé (rsa, ecdsa, ed25519, ...)

Si j'assemble les éléments donnés en exemple, ça donnerait:
`jsnow@winterfell,git,jonny@github.com,nopass.2022,rsa`

Quand je génère les clefs (avec `ssh-keygen`), j'utilise en commentaire (option `-C`) cette même structure, ce qui permet de s'y retrouver facilement quand on lit un fichier `authorized_keys` par exemple.

#### Plusieurs fichiers de configuration

Ca évite de mélancher tout les morceaux de configuration
ou bien d'écraser le fichier complet par inadvertance ou bien d'avoir une entrée en double pour la configuration d'un serveur (évidemment, quand ça arrive, on ne comprend pas pourquoi ça ne marche pas comme prévu).

Voici le contenu complet du fichier `.ssh/config` (oui c'est tout):

```
Include keyring.*/config
```

Voici le contenu de `.ssh/keyring.got/config` (fichier de configuration pour l'organisation GOT):

```
Host github.com
    # more options
    User root
    IdentityFile ~/.ssh/keyring.got/jsnow@winterfell_gitpush_jonny@github_pass_ed25519
```

Autre avantage, quand j'utilise des outils qui écrivent un bout de fichier de configuration, je n'ai plus peur de faire :

```shell-session
$ vagrant ssh-config > ~/.ssh/keyring.vagrant/config,
```

## Et vous ?

* Quelles sont vos stratégies pour gérer vos clefs ?

* Comment organisez vous votre configuration SSH ?

## Références

* [OCTO Talks: Gardez les clés de votre infrastructure à l’abri avec Vault](https://blog.octo.com/gardez-les-cles-de-votre-infrastructure-a-labri-avec-vault/)
* [Comparing SSH Keys - RSA, DSA, ECDSA, or EdDSA?](https://goteleport.com/blog/comparing-ssh-keys/)
