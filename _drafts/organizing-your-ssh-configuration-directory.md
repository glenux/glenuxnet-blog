---
layout: post
title: Organizing your ssh configuration directory
---

Avec le temps, on accumule des assets de différents projets

Tree structure of the `~/.ssh/` directory:

```
~/.ssh/
  |- keyring.organizationA/
  |    |- srcuser@srchost_action_dstuser@dsthost_details_cypher
  |    |- srcuser@srchost_action_dstuser@dsthost_details_cypher.pub
  |    |- srcuser@srchost_action_dstuser@dsthost_details_cypher
  |    |- srcuser@srchost_action_dstuser@dsthost_details_cypher.pub
  |    |- ...
  |    `- config
  |- keyring.organizationB/
  |    |- srcuser@srchost_action_dstuser@dsthost_details_cypher
  |    |- srcuser@srchost_action_dstuser@dsthost_details_cypher.pub
  |    |- srcuser@srchost_action_dstuser@dsthost_details_cypher
  |    |- srcuser@srchost_action_dstuser@dsthost_details_cypher.pub
  |    |- ...
  |    `- config
  |- keyring.organizationC/
  |    |- ...
  |    `- config
  |- authorized_keys
  |- known_hosts
  `- config
```

Content of the `.ssh/config` configuration file:

```
Include keyring.*/config
```

## Références

* [OCTO Talks: Gardez les clés de votre infrastructure à l’abri avec Vault](https://blog.octo.com/gardez-les-cles-de-votre-infrastructure-a-labri-avec-vault/)
