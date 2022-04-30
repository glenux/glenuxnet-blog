# Réduire la latence

## Apple M1, MacOS et la QoS

Récent article sur Hackernews à propos de la QoS d'Apple sur les processeurs M1)

FIXME: date ? lien ?

* Super intéressant
* Envie de faire pareil sur linux
* Tout en sachant que le CPU n'est pas le même et que ... ça n'aura pas le même impact sur la partie performance.

Objectif : réduire la latence de Linux sur un Intel Core i5

Nota-Bene: évidemment, sans le processeur M1 (qui est asymétrique en terme d'économie d'énergie / puissance) ça a peu de sens en terme de performances... puisqu'on se coupe de la moitié du processeur, en revanche en terme de latence les résultats sont nettement perceptibles.

## La bande passante et la latence

* Une sombre histoire de scheduling
* Probleme classique de l'allocation des ressources (scheduling, realtime, etc.)
* Longue histoire au niveau Linux
* différents schedulers qui cherchent à résoudre le probleme avec une stratégie "générique"
* mais...  ça dépend aussi du matériel
* mais... ça dépend aussi de l'usage
* des fois il faut "aider" le scheduler à la main (selon ce qu'on cherche à faire)

## Vue d'ensemble

* on cherche à déplacer les processus utilisateur

* on cherche à déplacer les processus système

* on cherche à déplacer les processus kernel
  
   * les worker threads
   * la gestion des IRQ
   * les autres kernel threads

* on veut mesurer / comparer les performances
  
   * bande passante (temps minimum de calcul pour une appli utlisateur)
   * latence

## Déplacer les processus utilisateur

✅ Déplacer les proc. user sur CPU 2-3
.... via systemd user.slice + CPUAffinity

✅ Déplacer les proc. systeme sur CPU 0-1 
.... via system system.conf + CPUAffinity

✅ Déplacer la gestion du desktop (KDE/plasma) sur CPU 0-1
.... via systemd --user + services + CPUAffinity + delegate des cpusets

✅ Déplacer les kernels workers threads sur CPU 0-1 
.... avec des `echo .. > /sys/devices/virtual/workqueue/*/cpumask`

✅ Déplacer la gestion des IRQ sur CPU 0-1
.... avec des `echo .. > /proc/irq/*/smp_affinity_list`
.... puis gestion des IRQ en tant que kernel theads au lieu de IRQ context (avec l'option kernel `threadirqs`)

❌ Déplacer les autres kernels threads sur CPU 0-1 
.... cpuset ne fonctionne plus avec les cgroups2 
.... cgget/cgset n'accepte pas les mêmes options 😱

Une idée ?

Ping Jean-Baptiste Yunès, François Armand, Roland Laurès, Jérôme Arzel

> Quelle latence veux tu réduire ? J'imagine qu'il s'agit de la réactivité globale du système sur un PC utilisateur ? Donc interactions utilisateur, et probablement attente des requêtes réseau ? 

> Quand je trouve que mon système ressemble à un paresseux, en général, j'attends un retour réseau... Du coup les petites astuces locales risquent d'être peu significatives ?

Pour l'instant j'ai observé la quantité d'IO gérée par CPU et la quantité de context-switch.

En effet, les IO visibles / lentes sont celles les disques (pas SSD) et celles du réseau

FIXME: vérifier ?

> En début d'année, j'ai joué avec des cgroups v1 pour optimiser l'empilement de VM sur des serveurs. Vu la vétusté des systèmes hôtes installés, pas pu jouer avec les cgroups V2 (sauf sur mon PC).

Effectivement les cgroups V2 ont une granularité plus fine au niveau de /sys/ mais je n'ai pas eu le courage de lire toute la doc kernel à ce sujet... et les outils & techniques mentionnés dans toutes autres docs que j'ai lu concernent les cgroupsv1. 

En effet, il va falloir faire des ioctl ou aller jouer avec fichiers de /sys

J'essayais d'esquiver, mais crois que je vais devoir RTFM du coup :)

FIXME: quelle est la différence entre cgroups v1 et v2 ?

> Est-ce que tu ne peux pas faire des echo dans les fichiers cgroup v2 pour contourner tes pbs de cgset ?
> Les cgroups V2 ont des "prises" pour les I/O latency... T'as essayé ?

Pas encore :)

> Comme tu dis, du coup tes CPU 0-1 dédiés au système vont pas avoir besoin de refroidissement.

FIXME: comment est fait le refroidissmeent des CPU sous linux ?

> T'as regardé comment les CPU 0-1 étaient "mappés" sur les cores ? Souvent la numérotation linéaire des CPU est mappée de manière discontinue sur les sockets/core... Du coup, il serait peut-être mieux de focaliser le kernel sur 0 et 2 ?

Je me suis fait la remarque, mais je n'ai pas regardé les détails de ce coté là.
J'ai vérifié les question de NUMA / distance à la mémoire. Ici c'est égal pour tous les CPU.

FIXME: comment savoir comment les CPU sont mappés sur les cores ?

> Ça me rappelle les tentatives de Vincent Minet (un de tes successeurs à P7) sur un TP de benchmark de changement de contexte. Il avait isolé son application de benchmark, sur des CPU et contenu les IRQ sur d'autres... Si ça se trouve, j'ai peut-être encore son compte-rendu de TP dans mes archives. Au prochain confinement, je fouillerai. Et malgré tout le résultat n'était pas constant, il y avait des perturbations dont nous n'avons pas trouvé l'origine... A l'époque le noyau Linux n'avait pas tous les outils de configuration dont on dispose actuellement, la situation s'est probablement améliorée.

> Vu que t'as essayé, t'as des mesures avant / après ?

FIXME: comment faire des mesures sur la latence

FIXME: comment mesurer où sont distribuées les IO ?

FIXME: commenr mesurer le temps processus sur chaque CPU

## Références

* [Troubleshooting High I/O Wait in Linux](https://bencane.com/2012/08/06/troubleshooting-high-io-wait-in-linux/)
* https://haydenjames.io/linux-server-performance-disk-io-slowing-application/
* [Throttle per process I/O with max limit](https://unix.stackexchange.com/questions/48138/how-to-throttle-per-process-i-o-to-a-max-limit)
   - cgroup + blkio controller
* [Using cgroups to limit I/O](https://andrestc.com/post/cgroups-io/)

Context switching

* https://unix.stackexchange.com/questions/466374/how-to-change-linux-context-switch-frequency
* https://unix.stackexchange.com/questions/466722/how-to-change-the-length-of-time-slices-used-by-the-linux-cpu-scheduler/466723#466723

## Monitoring

* https://eli.thegreenplace.net/2018/measuring-context-switching-and-memory-overheads-for-linux-threads/

## Notes

* Préciser que ça dépend du IO scheduler (elevator=bfq / elevator=noop / etc.)
* 

FIXME: il se passe quoi avec le reatime ? 
