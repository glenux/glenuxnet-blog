---
layout: post
title:  la-fin-des-flocons-de-neige
date:   2015-08-03 09:00:15
categories: []
tags:   []
published: false
---

Une idée venue d'après une série de liens en anglais:

* [Pets vs. Cattle](https://blog.engineyard.com/2014/pets-vs-cattle)
* [Version 2: Now with More Cows](http://pistoncloud.com/2013/04/announcing-enterprise-openstack-version-2/)
* [Netflix tue aléatoirement son infrastructure pour vérifier sa haute disponibilité](http://techblog.netflix.com/2010/12/5-lessons-weve-learned-using-aws.html)
* [SnowflakeServer](http://martinfowler.com/bliki/SnowflakeServer.html) 
* [The Noflake Manifesto](http://noflake.org/)

----

Nous vivons un changement de paradigme.

Les nouvelles techniques de virtualisation, d'automatisation et de collaboration amènent les entreprise à repenser la façon de concevoir et d'exploiter leurs systèmes d'information.

Les serveurs d'entreprises, historiquement gérée artisanalement par leurs administrateurs système sont remplaées par des infrastructures externalisées et d'appoint (IaaS / PaaS).

Du serveur "de compagnie" ... à l'infrastructure en "bétail"
FIXME: Les enjeux (1 §)
- apporter de meilleures garanties (cf snowflake servers)
- apporter de la scalabilité
- gagner du temps / faire des économies

FIXME: Rappel sur les anciennes pratiques (1 à 2 §)
- serveurs géres avec amour par un/des admins (n'avez vous jamais nommé vos serveurs d'après les planetes de starwars ou les personnages de tolkien)
- idée de serveur physique
- configuration faite à la main & documentée si possible
- une panne => panique totale & difficulté de reprise
- temps interruption => plusieurs jours/semaines

FIXME: les nouvelles technologies (1 à 2§)
- devops
- containers
- automation
- configuration gérée sous VCS
- build & déploiement automatisé
- panne => relancer l'instance ou redéploiement d'une nouvelle version
- temps interruption de l'ordre de minute ou de la seconde



Le coût du changement

FIXME: Le contexte / l'usage
C'est évidemment déjà le adopté chez les opérateurs, les géants du cloud (google, fb, etc.) qui sont les premier à fournir publiquement ce genre solutions à partir de leurs développement internes (ex: kubernetes => google)

Nous rencontrons de plus en plus souvent des petites sociétés qui font le pas de remplacer leurs quelques "gros" serveurs par des instances légères et totalement dynamiques.

Ces technologies ont le vent en poupe mais il pourrait ne s'agir que d'un effet de mode.

En effet, la mise en place d'un système de containers/etc. nécessite de nombreuses couches d'abstraction supplémentaires et font entrer en scène de technologies sur lesquelles les entreprises n'ont pas encore assez de recul et qui nécessiteront des compétences supplémentaires dans les équipes pour leur gestion.

FIXME: rappels : couche réseau, autodétection des containers, reverse proxy, load-balncing. etc.

FIXME: Necessité pour l'entreprise de gérer ces changements, ce risque et ces nouvelles compétences.

Comment bien faire la transition
FIXME: les points à prendre en compte
FIXME: Les conditions de réussite

Questions ouvertes :

Avez-vous franchi le pas ? Comment adresses vous ces nouvelles contraintes ?

(encadré) L'expérience de netcat_
Depuis 2010, netcat_ apportent des solutions pour qualifier des déploiements logiciels aussi bien sur des parcs de serveurs, que pour des systèmes autonomes déployés sur le terrain.

FIXME: quid des questiosn de souverainetés (cf BFM w/ Iteanu & cloudwatt)
