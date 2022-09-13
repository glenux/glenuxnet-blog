---
layout: post
title: Mieux organiser votre dossier de configuration SSH
---

Avec le temps, j'ai accumulé des clés SSH et de la configuration pour de
nombreux projets, services et serveurs.

Au début je stockais toutes les clefs directement dans le dossier `~/.ssh/` et
toute la configuration dans `~/.ssh/config`, mais évidemment ça n'a pas tenu
bien longtemps.  Il fallait maintenir la configuration propre, éviter le risque
de tout perdre en cas de fausse manipulation, et puis surtout retrouver quelle
clef correspondait à quoi : quel serveur ? en quelle année ? faut-il encore
l'utiliser ? etc.

Alors certes, il est [très fortement recommandé d'utiliser des certificats
SSH](https://smallstep.com/blog/use-ssh-certificates/) plutôt que des clefs SSH
pour ne plus se poser ces questions. Cependant même en faisant les choses
correctement chez vous, vous aurez quand même souvent besoin de bêtes clefs
asymétriques car la majorité des services en ligne n'acceptent pas le systeme
de certificats SSH. Donc il faut gérer tout ces clefs. 

J'ai eu plusieurs stratégie de rangement, évidemment, mais dont je vous avoue
que je ne me souviens plus trop les détails. Cependant elles ont chacune
atteint leur limite. 

J'en suis arrivé à la structure suivante, qui est celle que j'utilise
actuellement, pour le dossier `~/.ssh/`:

```
~/.ssh/
  |- keyring.organization-a/
  |    |- key1
  |    |- key1.pub
  |    |- key2
  |    |- key2.pub
  |    |- ...
  |    `- config
  |- keyring.organization-b/
  |    |- key3
  |    |- key3.pub
  |    |- key4
  |    |- key4.pub
  |    |- ...
  |    `- config
  |- keyring.organizationC/
  |    |- ...
  |    `- config
  |- authorized_keys
  |- known_hosts
  `- config
```

#### Bien nommer ses clefs pour les retrouver

Evidemment, je n'appelle pas mes clefs `key1` ou  `key2`. J'utilise un _schéma
de nommage_, c'est à dire une structure sémantique invariable pour nommer
mes clefs SSH. 

J'utilise la structure suivante: 
`SrcUser@SrcHost,Action,DstUser@DstHost,Details,Cypher`.

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

Quand je génère les clefs (avec `ssh-keygen`), j'utilise en commentaire (option
`-C`) cette même structure, ce qui permet de s'y retrouver facilement 
quand on lit un fichier `authorized_keys` par exemple.


#### Plusieurs fichiers de configuration

Ca évite de mélancher tout les morceaux de configuration
ou bien d'écraser le fichier complet par inadvertance
ou bien d'avoir une entrée en double pour la configuration d'un serveur (évidemment, quand ça arrive, on ne comprend pas pourquoi ça ne marche pas comme prévu).

Voici le contenu complet du fichier `.ssh/config` (oui c'est tout):

```
Include keyring.*/config
```

Voici le contenu de `.ssh/keyring.got/config` (fichier de configuration pour
l'organisation GOT):

```
Host github.com
    # more options
    User root
    IdentityFile ~/.ssh/keyring.got/jsnow@winterfell_gitpush_jonny@github_pass_ed25519
```




## Références

* [OCTO Talks: Gardez les clés de votre infrastructure à l’abri avec Vault](https://blog.octo.com/gardez-les-cles-de-votre-infrastructure-a-labri-avec-vault/)
* [Comparing SSH Keys - RSA, DSA, ECDSA, or EdDSA?](https://goteleport.com/blog/comparing-ssh-keys/)
