# Instagram_clone

## Description

Instagram_clone est une copie de l'application instagram.

## Architecture

Le projet utilise **Firebase** pour la base de données.
Le front-end est réalisé avec **Flutter**.
L'application fonctionne actuellement sur **Android** et **Web**
L'IDE utilisé pour son développement est **Android Studio**

## Infos

⚠**Toujours en cours de développement**⚠

**Edit le 13 JUIN 2023**

## Installation

Voici les étapes à réaliser pour la mise en place et le bon fonctionnement du projet:

1 Création d'un projet sur le site Firebase console.
2 Ajouter 2 applications à ce projet (1 pour le Web, 1 pour Android).
3 Création d'un nouveau projet depuis l'IDE Android Studio:
  3.1 File -> New -> Project from Version Control
  3.2 Entrer l'URL suivante : https://github.com/COMMUNIER-Pierrick/instagram_clone_flutter
4 Entrer cette commande dans le terminal de l'IDE: flutter pub get
5 Création d'un nouveau dossier "config" à la racine du dossier "lib"
  5.1 Création d'un fichier "web" à l'intérieur du dossier "config"
  5.2 Aller dans les paramètres de votre projet firebase (sur le site Firebase console) puis sélectionner votre application web.
      Vous y trouverez les constantes utiles pour la configuration web de Firebase à mettre dans votre projet Android Studio.
  5.3 Copier puis coller les constantes suivantes dans le fichier "web" afin d'obtenir ceci:
    const apikey = "Votre clé";
    const appId = "Votre clé";
    const messagingSenderId = "Votre clé";
    const projectId = "Votre clé";
    const storageBucket = "Votre clé";
6 Aller dans les paramètres de votre projet firebase (sur le site Firebase console) puis sélectionner votre application Android.
  6.1 Télécharger le fichier "google-services.json".
  6.2 Ajouter ce fichier à la racine du dossier suivant:
      "Non du dossier du projet" -> "android" -> "app" -> "src"

Vous devriez maintenant pouvoir utiliser cette application que j'ai créée.
Libre à vous de la personnaliser et de la modifier à votre convenance ;)
