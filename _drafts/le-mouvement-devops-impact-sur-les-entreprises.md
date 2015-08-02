---
layout: post
title:  La-révolution-Devops--l-impact-sur-les-entreprises
date:   2015-07-09 09:00:15
categories: []
tags:   []
---

## META

Titres

* L'entreprise post-DevOps
* DevOps: révolution en entreprise ?

A lire

* https://medium.com/@donaldguy/what-is-devops-1150f318a567
* [The LeedsDevops Manifesto](http://www.leedsdevops.org.uk/post/62089905741/the-leedsdevops- manifesto)
* https://www.reddit.com/r/devops/comments/2xp4ly/the_devops_landscape_right_now/

Affirmations

* devops est une mode, qui va s'estomper. C'est un cri face aux nouvelles possibilités et aux nouveaux outils. Mais cela va devenir "normal".
  
  > When something is hot in tech, people make it out to be like a movement of ideals. After it fades from popularity, people forget about the religious stuff and focus on what it can do for their business.
  
  > **/u/fundieInAChainWay** : Everyone is devopsing, while I'm just here sysadmining.

* les recruteurs d'aujourd'hui ne comprennent pas :)

## What is devops ?

I actually really like Adam Jacob's definition:

> "DevOps is the word we use to describe the operational side of the transition to enterprises being software-led".
> It's about a way of doing work. It's not a job you have. People hate hearing this, but it's like calling yourself an "agile".

Devops is:

* A technical and cultural movement with automation at its core
* A faster and safer way to deliver value to customers
* A set of practices established by web innovators that are now being adopted by enterprises of all kinds.

**/u/soawesomejohn**:  

> [...] DevOps is a culture - a combination of Operations people and Developer people.  [...]

> The key here is the part where the Ops people and the Devs are working together to automate everything. It's not just about automation, but repeatability. Your QA and Staging environments will probably have to get rebuilt to specific versions all the time, so you have to go from bare metal/virtual to working environment quickly and with minimal human involvement.

> [...]  I'm definitely in the "sysadmin who does automation" camp.


FIXME: the definition on wikipedia ?

FIXME: mythes ?

FIXME: réalités / exemples ?

## Retours d'expérience

> **/u/ohcrapitssteve** : DevOps has changed the way I do Sysadmin stuff; I realize a lot of DevOps folks came to the table from the Dev side. I came from the ops side and love it. 

> **/u/radeky** : To me, DevOps is about adopting those practices which allow you to serve your customers better. In your example, the UAT team is the customer and your work with AWS and Chef is what allows them (and you) to do their jobs more efficiently than if you were in the datacenter inserting boot cds into trays.

## Le paysage devops aujourd'hui

## 


﻿ 
Devops ne designe pas les outils mais plutot les gens et leur maniere de travailler. Mais en fait, ca designe plus des principes qu'une reelle methode ou un poste défini.
DevOps est la contraction de Developer - Operations (dans le sens "exploitant"). Autrement dit, c'est la reunion des dev et des admins sys grosso modo et ca provient effectivement des methodes Agile.

En fait, il y a un constat depuis longtemps stipulant que c'est bien d'ameliorer la qualité logicielle et d'accelerer fortement les cycles de release mais si les types qui mettent en prod et gerent la prod ne suivent pas, ca sert a rien.
Un autre constat aussi est que bien souvent les dev travaillent dans le monde ou il faut produire vite, changer les choses vite et d'un autre ou la production necessite au contraire de la stabilité. Ainsi les equipes ont tendance a fonctionner en silos ou chacun reste de son coté de la barriere et ne communiquent que via des livrables ou des tickets d'incidents. 
Une derniere chose aussi, quand on est une startup, on a souvent peu de ressources et donc ce sont les devs qui font un peu tout donc ils codent mais ils doivent aussi se sortir les doigts pour gerer leur prod. Donc ils ont vite compris que l'integration, les tests de charge/perf/dispo, la doc, le packaging, etc sont aussi importants que les nouvelles fonctionnalités et les corrections de bugs. Et d'un autre coté, celles qui embauchaient des admins sys les integraient au sein des equipes des dev et ils devaient aussi se sortir les doigts pour etre aussi "agiles" que les copains
Bref, tout ca melangé a fait que les equipes de prod et de dev se sont sérieusement rapprochées les unes des autres au point que certains sont à cheval sur les 2. Dans tous les cas, l'idee est que les dev et les ops doivent travailler ensemble et pas les uns "contre" les autres comme c'est trop souvent le cas. 
Ainsi, pleins d'outils pour automatiser et provisionner des plateformes entieres (puppet, ansible, etc), faire des contenaires (docker), piloter des solutions de virtualisation par fichiers et scripts (vagrant) sont apparus, les admins sys se sont appropriés Git, etc
Au point qu'aujourd'hui, un devops "code" son infra : il la décrit dans des fichiers comme un dev code ses fonctionnalités. Puis il execute ses outils comme on compilerait du code et il obtient un resultat (une infra avec une configuration specifique) unique et reproductible.

Apres, les principes sont hyper interessants mais les outils sont encore en heavy dev. Autrement dit, ca bouge enormement en ce moment et c'est difficile de se tenir à jour. Et la qualité des outils est parfois variable… Quand on est un admin sys pur souche et qu'on cherche a embrasser cette maniere de faire, c'est parfois un peu rugueux et ca choque de confier son infra a des outils qu'on sait etre encore un peu verts. Et surtout, ca n'ote pas la necessite de bien connaitre et savoir parametrer les services qu'on installe donc ca fait une couche technique supplementaire a connaitre et maintenir. 
De plus, cette facon de faire ne s'applique pas partout et dans tous les contextes pro. Ca marche bien quand les devs sont deja en agile avec des technos modernes. Ca marche moins bien quand il y a un vieil existant produit et géré "à l'ancienne" (enfin, ca pourrait marcher mais le ticket d'entrée est tres lourd pour mettre ca en place).
C'est extremement bien adapté au Cloud (type AWS par exemple).

Au final, pour moi, c'est une vraie revolution dans le monde et dans le petit train-train de l'exploitation/production et des admins sys en general. Une revolution équivalente à l'arrivée de la virtualisation, je pense.
C'est vraiment passionnant et ca nous (les sysadmins) oblige a remettre en cause nos manieres de faire et de voir les choses. D'un autre coté, ca force aussi les devs a prendre en compte le cycle de vie entier de leur code et pas s'en laver les mains une fois que le zip a ete balancé a l'exploitation. 
Je pense que tout le monde y gagne a se serrer les coudes et travailler ensemble…

Désolé pour le pavé :)