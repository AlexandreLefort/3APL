# SupFamily

Application de Geolocalisation avec sauvegarde en local.

## Getting Started

Ici, un bref tutoriel pour le deployement le bon fonctionnement de l'application.

### Prerequisites

- Xcode 9.4

### Installing

1. Telechargez et decompresser l'archive ZIP fournit ( 3APLGBL.zip )

Lancer le fichier :

```
3APL_GBL.xcworkspace
```
Et non pas ```3APL_GBL.xcodeproj``` car ce dernier ne contient pas les dependances neccesaires au bon fonctionnement de l'application

Vous pouvez maintenant lancer les vos tests en ligne et hors ligne !

## Running the tests

Lors du lancement de l'application, vous serrez confronté a un une page de login.

Connectez vous en ligne ou hors-ligne avec les identifiants :
```
Identifiant : admin
Mot de passe : admin
```
Vous etes dorenavant connecté.

3 pages sont a votre dispositions :

- Search : qui affiche la map des membres de la famille.
- Contacts qui liste les differents membre de la famille.
- More qui permet notament de se deconnecter.

### Search :

Elle affiche Une map avec les differents membres de la famille.

### Contacts : 

Liste les membre(s) de la famille a chaque affichage de la page. 

Si il y a de la connexion, les membres sont rafraichis via API dans le cas echeant via SQLITE :
    - Posibilité de supprimer les contacts ( dans le cas de l'api en ligne, impossible de les modifier car l'API est EN DUR mais pas de probleme en hors ligne) en slidant vers la gauche.
    - Possibilité d'ajouter des contacts via le bouton "+" en haut a droite. encore une fois l'api fournit par supinfo ne permet pas d'ajouter des membres mais le contact est tout de meme ajouté en SQLITE.

La page est rafraichie a chaque changement ce qui permet de gerer les pertes de connexion

Lorsqu'il n'y a plus de connexion, la base de données SQLITE prends le relais et permet le stockage de données

### More

Permet de se déconnecter et hors-ligne ou en ligne

## Built With

## Authors

* **Alexandre LEFORT** - *dev* - [AlexandreLEFORT](https://github.com/PurpleBooth)

* **Marin Godart** - *dev* - [AlexandreLEFORT](https://github.com/PurpleBooth)

* **Aiman BAHOUALA** - *dev* - [AlexandreLEFORT](https://github.com/PurpleBooth)
