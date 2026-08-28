# Projet DevOps · velos-api

**Nom et prénom :** EL KHADIMI Rania
**Groupe :** M2DAN26.1
**Dépôt :** https://github.com/raniaelkhadimipro-ship-it/velos-api
**Image publiée :** `raniakdm/velos-api`
**Date de rendu :** 28/08/2026

---

## 1. Ce que j'ai construit, en cinq lignes

Dans ce projet, j'ai mis en place une chaîne DevOps complète autour de l'application `velos-api`.

J'ai commencé par versionner le projet avec Git et GitHub, puis j'ai travaillé sur la conteneurisation de l'application avec Docker.

J'ai ensuite déployé l'application dans Kubernetes afin de gérer plusieurs instances, tester sa disponibilité et effectuer des mises à jour ou des retours arrière.

Enfin, j'ai commencé à mettre en place Jenkins afin d'automatiser les différentes étapes de la chaîne, notamment les tests, la construction de l'image Docker et son déploiement.

L'objectif global était de comprendre et de mettre en pratique le passage du code source jusqu'à son déploiement dans une infrastructure conteneurisée.

---

## 2. Le trajet d'une requête

Lorsqu'un utilisateur accède à l'application depuis son navigateur, la requête passe par plusieurs composants.

Le navigateur envoie la requête vers le point d'accès de l'application. Le service Kubernetes reçoit ensuite cette requête et la transmet à l'un des pods disponibles exécutant l'application `velos-api`.

L'application traite la requête et communique avec la base de données lorsque cela est nécessaire.

Le trajet peut donc être résumé ainsi :

**Navigateur → Service Kubernetes → Pod `velos-api` → Base de données**

Kubernetes permet de répartir les requêtes entre les différents pods disponibles et de recréer automatiquement un pod lorsqu'un exemplaire est supprimé.

---

# 3. Jalon 1 · Git

### Ce que j'ai fait

J'ai utilisé Git pour versionner le projet et GitHub pour héberger le dépôt.

J'ai effectué plusieurs commits afin de conserver un historique des différentes étapes du développement. J'ai également utilisé les branches et les pull requests afin de travailler sur différentes modifications sans modifier directement la branche principale.

J'ai également travaillé avec des tags afin d'identifier certaines versions du projet.

Enfin, j'ai mis en place une protection de la branche principale afin de limiter les modifications directes et de favoriser le passage par une pull request.

### Le conflit

J'ai rencontré un conflit Git lors de modifications effectuées sur un même fichier.

Deux versions différentes du fichier existaient et Git ne pouvait pas déterminer automatiquement quelle modification devait être conservée.

J'ai dû examiner les différences entre les deux versions, comprendre les modifications apportées et choisir manuellement la version cohérente avec l'objectif du projet.

Cette résolution m'a permis de mieux comprendre le fonctionnement des conflits Git et l'importance de vérifier le code avant de valider une fusion.

### Ce que je retiens

Ce premier jalon m'a permis de mieux comprendre l'intérêt du versionnement dans un projet informatique.

J'ai retenu l'importance d'avoir un historique propre et des commits permettant de suivre les différentes étapes du projet.

La résolution du conflit m'a également permis de mieux comprendre les branches, les fusions et les pull requests.

![C01](captures/C01-historique.png)
![C02](captures/C02-conflit.png)
![C03](captures/C03-pull-request.png)
![C04](captures/C04-tag.png)
![C05](captures/C05-protection.png)

---

# 4. Jalon 2 · Docker

### Mesure du cache de construction

J'ai réalisé une première mesure avec une construction sans utiliser le cache Docker, puis une seconde construction en permettant à Docker de réutiliser les couches déjà construites.

| Situation                 | Durée mesurée      |
| ------------------------- | ------------------ |
| Construction sans cache   | **1 min 46,699 s** |
| Reconstruction avec cache | **16,334 s**       |

On constate une différence importante entre les deux constructions.

La première construction prend environ 1 minute 47 secondes, alors que la reconstruction avec le cache prend seulement un peu plus de 16 secondes.

Cette manipulation m'a permis de comprendre concrètement l'intérêt du cache Docker. Lorsque les éléments d'une couche n'ont pas changé, Docker peut réutiliser le résultat précédent au lieu de refaire toutes les opérations.

### Taille de l'image

| Version                          |     Taille |
| -------------------------------- | ---------: |
| Version naïve, un seul étage     | **208 MB** |
| Version finale, plusieurs étages | **195 MB** |

J'ai également comparé la taille de l'image construite avec le Dockerfile naïf et celle de la version finale.

La version naïve atteint 208 MB, tandis que la version finale est de 195 MB.

La différence n'est pas énorme en taille absolue, mais la version finale est mieux organisée grâce à la séparation des étapes de construction et d'exécution.

L'objectif du multi-stage n'est donc pas uniquement de réduire la taille de l'image. Il permet également de ne conserver dans l'image finale que ce qui est nécessaire à l'exécution de l'application.

### Ce que le fichier d'exclusion de construction évite d'envoyer

Le fichier `.dockerignore` permet d'exclure du contexte de construction les fichiers qui ne sont pas nécessaires à la création de l'image.

Il permet notamment d'éviter d'envoyer le dossier `.git`, des fichiers temporaires, des dépendances locales ou d'autres éléments inutiles.

Cela permet de réduire le contexte envoyé à Docker et d'éviter d'intégrer accidentellement des fichiers qui n'ont pas leur place dans l'image.

### Comment j'ai prouvé la persistance

J'ai vérifié la persistance des données en utilisant un volume afin que les données ne dépendent pas directement du cycle de vie du conteneur.

L'objectif était de vérifier qu'après l'arrêt ou la suppression du conteneur, les données pouvaient toujours être récupérées par un nouveau conteneur utilisant le même volume.

Cette manipulation m'a permis de comprendre la différence entre les données stockées directement dans le conteneur et les données conservées dans un stockage persistant.

### Ce que je retiens

Ce jalon m'a permis de comprendre plusieurs aspects importants de Docker.

J'ai notamment pu mesurer concrètement l'intérêt du cache : ma construction est passée de **1 min 46,699 s sans cache à 16,334 s avec cache**.

J'ai également constaté que l'organisation du Dockerfile a un impact sur l'image finale, avec une image naïve de **208 MB** contre **195 MB** pour ma version finale.

J'ai surtout retenu qu'un bon Dockerfile ne doit pas seulement permettre de lancer l'application. Il doit également être pensé pour être efficace à construire, reproductible et adapté à l'environnement d'exécution.

![C06](captures/C06-images-taille.png)
![C07](captures/C07-cache-mesure.png)
![C08](captures/C08-non-root.png)
![C09](captures/C09-pile-demarree.png)
![C10](captures/C10-api-base.png)
![C11](captures/C11-persistance.png)

---

# 5. Jalon 3 · Kubernetes

### Comment j'ai obtenu le port 8081 vers le cluster

J'ai utilisé la redirection de port de Kubernetes afin de rendre temporairement l'application accessible depuis mon ordinateur.

Le port local `8081` permet d'accéder au service présent dans le cluster sans avoir besoin d'exposer directement l'application sur Internet.

La redirection permet donc de faire communiquer le port de mon ordinateur avec le service déployé dans Kubernetes.

### Où vit le mot de passe, et pourquoi ce n'est pas un coffre-fort

Le mot de passe utilisé par l'application est stocké dans un objet Kubernetes de type Secret.

L'utilisation d'un Secret permet d'éviter de mettre directement le mot de passe dans les manifests de déploiement classiques.

Cependant, un Secret Kubernetes ne doit pas être considéré comme un coffre-fort absolu. Sa sécurité dépend notamment des droits d'accès au cluster et de la sécurisation de l'environnement Kubernetes.

Cette manipulation m'a permis de comprendre qu'il faut éviter de placer directement des informations sensibles dans le code source.

### Ce que j'ai observé en supprimant un exemplaire sous trafic

J'ai testé la suppression d'un pod alors que l'application était utilisée.

Les autres pods continuaient à assurer le fonctionnement de l'application. Kubernetes détectait ensuite que le nombre de pods disponibles n'était plus conforme à l'état souhaité et recréait automatiquement un nouvel exemplaire.

Cette manipulation m'a permis de voir concrètement l'intérêt de la réplication et du système d'état désiré de Kubernetes.

### La mise à jour vers la version 2

Lors de la mise à jour vers la version 2, j'ai pu observer le fonctionnement du déploiement progressif.

Kubernetes permet de remplacer progressivement les anciennes instances par les nouvelles afin de limiter l'interruption du service.

Cela permet d'effectuer une mise à jour tout en conservant une partie de l'application disponible pendant l'opération.

### Le retour arrière

J'ai également travaillé sur le mécanisme de rollback.

Lorsqu'une nouvelle version pose problème, Kubernetes permet de revenir à une révision précédente du déploiement.

Cela est particulièrement utile lorsqu'une nouvelle version introduit un problème après son déploiement.

### Ce que je retiens

Ce jalon m'a permis de mieux comprendre le fonctionnement de Kubernetes dans une situation proche d'un environnement réel.

J'ai notamment compris l'intérêt des pods, des services, des replicas, des secrets, des mises à jour progressives et du rollback.

J'ai également compris que Kubernetes cherche constamment à maintenir l'état réel du cluster en cohérence avec l'état souhaité défini dans les fichiers de configuration.

![C12](captures/C12-cluster.png)
![C13](captures/C13-ressources.png)
![C14](captures/C14-api-cluster.png)
![C15](captures/C15-echelle.png)
![C16](captures/C16-panne.png)
![C17](captures/C17-mise-a-jour.png)
![C18](captures/C18-retour-arriere.png)

---

# 6. Jalon 4 · Jenkins

### Mes tests

Les tests ont pour objectif de vérifier le comportement de l'application avant de poursuivre les différentes étapes du pipeline.

L'intérêt est de permettre à Jenkins de lancer automatiquement ces tests et de vérifier qu'une modification du code n'introduit pas de régression.

Les tests concernés ne nécessitent pas de base de données externe, ce qui permet de les exécuter directement dans le pipeline.

### Les quatre étapes de mon pipeline

La logique du pipeline Jenkins que j'ai travaillée est organisée autour de quatre grandes étapes :

1. récupération du code depuis Git ;
2. exécution des tests ;
3. construction et publication de l'image Docker ;
4. déploiement de l'application dans Kubernetes.

L'objectif était d'automatiser le passage du code source jusqu'au déploiement.

### Comment mes images sont étiquetées, et pourquoi

Les images Docker sont identifiées à l'aide de tags afin de pouvoir faire le lien entre une image et une version donnée du projet.

Cette organisation permet notamment de savoir quelle version de l'application est déployée et facilite les opérations de mise à jour ou de rollback.

### La ligne qui rend mon pipeline honnête

La partie importante du pipeline est le contrôle du résultat des tests avant de poursuivre vers les étapes suivantes.

Si les tests échouent, le pipeline doit s'arrêter.

Cela permet d'éviter qu'une version présentant déjà une erreur soit automatiquement construite puis déployée.

Sans cette vérification, Jenkins pourrait continuer son exécution alors que le code ne respecte déjà plus les tests définis.

### Le rouge utile

J'ai cherché à vérifier qu'un pipeline pouvait réellement passer au rouge lorsqu'une étape échoue.

L'objectif était de vérifier qu'une erreur détectée avant le déploiement empêchait la nouvelle version d'être envoyée automatiquement dans le cluster.

Dans ce cas, la version précédente déjà présente dans Kubernetes peut continuer à fonctionner.

Cette manipulation permet de montrer que le pipeline ne doit pas simplement automatiser toutes les commandes les unes après les autres : il doit également empêcher la propagation d'une version qui ne respecte pas les contrôles prévus.

### L'extrait de journal qui donne la cause

Sur la fin du travail sur Jenkins, j'ai rencontré un problème lors de l'utilisation du CLI Jenkins.

La commande utilisée était :

```text
docker exec jenkins java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 who-am-i
```

J'ai obtenu le résultat suivant :

```text
CLI handshake failed with status code 403
```

avec notamment :

```text
X-CLI-Error: Unexpected request origin (check your reverse proxy settings)
```

Cette erreur était importante pour mon diagnostic.

J'avais initialement vérifié si le problème pouvait venir de Java. Cependant, Java était bien présent dans le conteneur Jenkins.

J'ai donc utilisé directement le Java présent dans le conteneur plutôt que d'installer Java sur Ubuntu.

J'ai également copié le fichier `jenkins-cli.jar` dans le conteneur Jenkins.

La commande fonctionnait jusqu'au moment du handshake avec Jenkins, mais le serveur refusait alors la requête avec une erreur HTTP `403`.

Le message `Unexpected request origin` indiquait donc davantage un problème de vérification de l'origine de la requête ou de configuration du reverse proxy qu'un problème lié à Java.

### Où je me suis arrêté

**C'est à ce niveau que je me suis arrêté sur le Jalon 4.**

J'avais réussi à avancer dans la mise en place et la compréhension du pipeline Jenkins, mais je n'ai pas réussi à finaliser et à valider toute la chaîne Jenkins de bout en bout.

J'ai notamment vérifié que Java était disponible dans le conteneur Jenkins :

```text
docker exec jenkins java -version
```

J'ai ensuite copié le CLI Jenkins dans le conteneur :

```text
docker cp /tmp/jenkins-cli.jar jenkins:/tmp/jenkins-cli.jar
```

Puis j'ai tenté d'utiliser le CLI :

```text
docker exec jenkins java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 who-am-i
```

C'est cette dernière commande qui a échoué avec le `403`.

J'ai également vérifié la présence du compte utilisateur Jenkins afin de poursuivre le diagnostic. Le compte `RaniaKDM` était bien présent dans la configuration utilisateur Jenkins.

À ce stade, je n'ai pas réussi à résoudre complètement le problème de communication avec le CLI.

Je n'ai pas voulu modifier ou redémarrer Jenkins au hasard afin de ne pas risquer de dégrader l'environnement déjà mis en place.

Je considère donc que **le Jalon 4 est partiellement réalisé mais non finalisé**.

### Ce que je retiens

J'ai compris que Jenkins est le lien entre les différentes étapes de la chaîne DevOps.

Le pipeline permet de relier Git, les tests, Docker et Kubernetes afin d'automatiser le processus.

Cette partie m'a également permis de comprendre l'importance des logs. Lorsqu'un problème apparaît, le résultat final ne suffit pas : il faut regarder précisément l'étape qui échoue et le message retourné.

La partie Jenkins a été ma principale difficulté sur la fin du projet, notamment à cause de problèmes liés à mon ordinateur et à l'environnement Jenkins.

![C19](captures/C19-identifiants.png)
![C20](captures/C20-pipeline-vert.png)

---

# 7. Mes trois difficultés

| # | Symptôme observé                                                              | Cause réelle                                                                                                                                       | Correction apportée                                                                                                                                                                                           |
| - | ----------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | Difficultés à reproduire certaines manipulations dans mon environnement local | Mon ordinateur et mon environnement de travail ont rencontré différents problèmes pendant le projet                                                | Je suis revenu sur les supports de cours et les TP afin de reprendre les étapes et les commandes une par une                                                                                                  |
| 2 | Difficultés sur Jenkins et notamment lors de l'utilisation du CLI             | Le problème ne venait finalement pas de Java mais d'un refus du serveur Jenkins lors du handshake, avec une erreur `403 Unexpected request origin` | J'ai vérifié Java dans le conteneur, copié le CLI Jenkins dans le conteneur et analysé les messages d'erreur                                                                                                  |
| 3 | Difficulté à finaliser Jenkins dans le temps disponible                       | Les problèmes rencontrés sur mon ordinateur et avec Jenkins m'ont fait perdre beaucoup de temps sur la fin du projet                               | J'ai utilisé les supports et les TP en priorité puis, face aux difficultés importantes de fin de projet, j'ai utilisé ponctuellement une IA pour m'aider à comprendre les erreurs et poursuivre le diagnostic |

---

# 8. Ce qui n'est pas fait

La majorité des étapes demandées dans le projet a été réalisée.

Le principal élément qui reste incomplet concerne **le Jalon 4 · Jenkins**.

J'ai avancé sur la mise en place et la compréhension du pipeline, mais je n'ai pas réussi à valider complètement la chaîne Jenkins de bout en bout.

Mon principal blocage est apparu lors de l'utilisation du CLI Jenkins.

Java était bien disponible dans le conteneur Jenkins et le fichier `jenkins-cli.jar` avait bien été copié dans le conteneur.

Cependant, la commande :

```text
docker exec jenkins java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 who-am-i
```

retournait :

```text
CLI handshake failed with status code 403
```

avec :

```text
X-CLI-Error: Unexpected request origin (check your reverse proxy settings)
```

J'ai donc identifié que le problème se situait au niveau de la communication avec Jenkins et de la vérification de l'origine de la requête.

J'ai également vérifié que le compte utilisateur Jenkins était bien présent.

Je me suis arrêté à ce stade, sans modifier la configuration de Jenkins ou redémarrer le serveur de manière hasardeuse.

Je considère donc que **le Jalon 4 est la partie non complètement finalisée du projet**.

Je préfère le signaler clairement plutôt que de présenter une automatisation Jenkins comme complètement fonctionnelle alors que je n'ai pas pu effectuer toutes les vérifications finales.

---

# 9. Assistance utilisée

Ma première source d'aide pendant le projet a été **les supports de cours**.

Je suis également revenu plusieurs fois sur **les TP réalisés pendant le cours**, qui m'ont servi de référence pour retrouver les commandes et comprendre la logique des différentes étapes.

Ces ressources m'ont particulièrement aidé sur Git, Docker et Kubernetes. Lorsque je rencontrais une difficulté, je reprenais les manipulations du TP afin de comprendre la démarche plutôt que de simplement chercher une commande à copier.

J'ai également utilisé les messages d'erreur retournés par les différents outils pour essayer d'identifier l'origine des problèmes.

Sur la fin du projet, j'ai rencontré des difficultés plus importantes, notamment avec **mon ordinateur et Jenkins**.

J'ai d'abord essayé de résoudre ces problèmes avec les supports de cours, les TP et l'analyse des erreurs.

Lorsque je me suis retrouvé face à des difficultés importantes et que je n'arrivais plus à progresser seul, j'ai utilisé **ponctuellement une IA comme aide au diagnostic**.

L'IA m'a principalement aidé à :

* comprendre certains messages d'erreur ;
* identifier des pistes possibles ;
* vérifier la logique de certaines commandes ;
* comprendre certains problèmes liés à Jenkins ;
* poursuivre le diagnostic lorsque je ne savais plus dans quelle direction chercher.

Un exemple concret est le problème du CLI Jenkins. J'avais initialement envisagé un problème lié à Java, mais la vérification a montré que Java était bien disponible directement dans le conteneur Jenkins.

Le problème était ensuite lié au handshake avec Jenkins, qui retournait une erreur `403 Unexpected request origin`.

Je précise donc que l'IA a été utilisée **principalement sur la fin du projet et en cas de grosse difficulté technique**, et qu'elle ne constitue pas ma principale source de travail.

Les supports de cours et les TP restent les ressources qui m'ont le plus aidé à comprendre et réaliser les différentes étapes du projet.

---

# 10. Si j'avais deux jours de plus

Si j'avais eu deux jours supplémentaires, ma priorité aurait été de terminer complètement le Jalon 4.

J'aurais consacré davantage de temps à résoudre le problème de communication avec Jenkins et son CLI afin de pouvoir valider toute la chaîne CI/CD de manière reproductible.

Je voudrais notamment pouvoir réaliser plusieurs scénarios avec Jenkins :

* un pipeline qui se termine correctement ;
* un pipeline volontairement en échec afin de vérifier que le déploiement est bien bloqué ;
* une nouvelle exécution réussie permettant de confirmer le fonctionnement complet de la chaîne.

Je compléterais également les captures et les mesures demandées dans les différents jalons.

Enfin, je prendrais le temps de stabiliser mon environnement local afin de pouvoir reproduire plus facilement les manipulations sans perdre autant de temps sur des problèmes liés à l'ordinateur.

---

# Conclusion

Ce projet m'a permis de mettre en pratique plusieurs outils importants de l'écosystème DevOps : Git, Docker, Kubernetes et Jenkins.

J'ai progressivement compris comment ces outils s'articulent entre eux : Git permet de versionner le code, Docker de construire une application reproductible, Kubernetes de gérer son exécution et Jenkins d'automatiser les différentes étapes.

Les supports de cours et les TP ont été essentiels dans ma progression. Je suis régulièrement revenu dessus lorsque je bloquais afin de reprendre les concepts et les commandes.

La principale difficulté s'est située sur la fin du projet avec Jenkins, en parallèle de problèmes rencontrés avec mon ordinateur. Malgré plusieurs tentatives de diagnostic, je n'ai pas réussi à finaliser complètement cette partie.

Je me suis arrêté précisément lors du diagnostic du CLI Jenkins, après avoir vérifié que Java était disponible dans le conteneur et que le CLI pouvait être exécuté, mais avec un refus `403` lors du handshake :

```text
CLI handshake failed with status code 403
X-CLI-Error: Unexpected request origin (check your reverse proxy settings)
```

Cette difficulté m'a néanmoins permis de mieux comprendre l'importance du diagnostic dans un environnement DevOps et de ne pas considérer automatiquement qu'une erreur vient de l'outil que l'on est en train d'utiliser.

Même si le Jalon 4 n'a pas été complètement finalisé, les autres étapes du projet m'ont permis de mieux comprendre la logique générale d'une chaîne DevOps et les interactions entre les différents outils.
