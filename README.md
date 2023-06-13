# Instagram_clone

## Description

Instagram_clone est une copie de l'application instagram.

## Architecture

Le projet utilise **Firebase** pour la base de données.<br>
Le front-end est réalisé avec **Flutter**.<br>
L'application fonctionne actuellement sur **Android** et **Web**<br>
L'IDE utilisé pour son développement est **Android Studio**<br>

## Infos

⚠**Toujours en cours de développement**⚠

**Edit le 13 JUIN 2023**

## Installation

Voici les étapes à réaliser pour la mise en place et le bon fonctionnement du projet:
<pre>
1 - Création d'un projet sur le site Firebase console.<br>
2 - Ajouter 2 applications à ce projet (1 pour le Web, 1 pour Android).<br>
3 - Création d'un nouveau projet depuis l'IDE Android Studio:<br>
  3.1 - File -> New -> Project from Version Control<br>
  3.2 - Entrer l'URL suivante : https://github.com/COMMUNIER-Pierrick/instagram_clone_flutter<br>
4 - Entrer cette commande dans le terminal de l'IDE: flutter pub get<br>
5 - Création d'un nouveau dossier "config" à la racine du dossier "lib"<br>
  5.1 - Création d'un fichier "web" à l'intérieur du dossier "config"<br>
  5.2 - Aller dans les paramètres de votre projet firebase (sur le site Firebase console) puis sélectionner votre application web.<br>
        Vous y trouverez les constantes utiles pour la configuration web de Firebase à mettre dans votre projet Android Studio.<br>
  5.3 - Copier puis coller les constantes suivantes dans le fichier "web" afin d'obtenir ceci:<br>
    const apikey = "Votre clé";<br>
    const appId = "Votre clé";<br>
    const messagingSenderId = "Votre clé";<br>
    const projectId = "Votre clé";<br>
    const storageBucket = "Votre clé";<br>
6 - Aller dans les paramètres de votre projet firebase (sur le site Firebase console) puis sélectionner votre application Android.<br>
  6.1 - Télécharger le fichier "google-services.json".<br>
  6.2 - Ajouter ce fichier à la racine du dossier suivant:<br>
        "Non du dossier du projet" -> "android" -> "app" -> "src"<br>
7 - Lancer l'émulation de l'application dans Android Studio à partir du fichier "main" qui se trouve dans le dossier "lib"</pre>

Vous devriez maintenant pouvoir utiliser cette application que j'ai créée.<br>
Libre à vous de la personnaliser et de la modifier à votre convenance ;)<br>
