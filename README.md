# EDP_Octave

Une application du cours LEPL1103 (partie EDP) de l'[EPL] ([UCLouvain]) pour la visualisation de solutions d'équations aux dérivées partielles.

## Contenu

- [Fonctionnalités](#fonctionnalités)
- [Installation](#installation)
- [Installer octave](#installer-octave)

## Fonctionnalités

À l'aide d'une interface graphique, ce programme permet la résolution de 2 équations aux dérivées partielles:

- Équation de Laplace
    - Domaine rectangulaire
    - Domaine circulaire
- Équation d'onde
    - Domaine rectangulaire

### Équation de Laplace
Résoud l'équation de Laplace ![eq](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B120%7D%20%5CDelta%20u%20%3D%200)
pour un domaine soit rectangulaire, soit circulaire.  
Dans les deux cas, on n'autorise qu'une seule condition non-homogène de Dirichlet.

|![exemple LR](https://i.imgur.com/OLkfVoc.gif)|![exemple LC](https://i.imgur.com/3BlScKR.gif)|
|:---:|:---:|
|Exemple de domaine rectangulaire|Exemple de domaine circulaire|

### Équation d'onde
Résoud l'équation d'onde ![eq](https://i.imgur.com/RDzBxxG.png) pour un domaine rectangulaire.  
On autorise ici que deux conditions limite: une condition de Dirichlet et une de Neumann en t = 0.  
Comme l'équation est à 3 dimensions (2 spatiales et 1 temporelle), on peut choisir de montrer la solution à un temps donné ou de l'animer pour un intervalle donné.

|![exemple WS](https://i.imgur.com/nJYkIan.gif)|![exemple WA](https://i.imgur.com/7v92RKb.gif)|
|:---:|:---:|
|Exemple de solution pour un temps unique|Exemple de solution animée sur un intervalle de temps|

## Installation

Si vous ne possèdez pas octave (version 6.1), veuillez consulter la section [installer octave](#installer-octave)

### 1. Télécharger le dossier principal

Il suffit juste de cliquer sur le boutton **Code** du répertoire principal [EDP_Octave](https://github.com/Reshims/EDP_Octave).
<details>
  <summary>Image d'aide</summary>
    
  > ![img](https://i.imgur.com/ulzWdjj.gif)
</details>

### 2. Décompresser le fichier
### 3. Changer le chemin dans octave
### 4. Lancer 'main.m'

## Installer octave

Dans le cas ou vous ne possèdez pas encore ce language nécessaire au fonctionnement de ce programme,
vous pouvez l'installer en le téléchargeant depuis [son site](https://www.gnu.org/software/octave/index).

:exclamation: Octave nécessite ~1.7Go d'espace

### Téléchargement

Vous pouvez télécharger la dernière version d'octave [ici](https://www.gnu.org/software/octave/download.html)
ou chercher une version précise [ici](https://ftp.gnu.org/gnu/octave/).

<details>
  <summary>Image d'aide</summary>
  
  > ![img](https://i.imgur.com/HLF2sMp.png)
</details>

[EPL]: https://uclouvain.be/fr/facultes/epl
[UCLouvain]: https://uclouvain.be/fr/index.html
