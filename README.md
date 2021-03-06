# EDP_Octave
Une application du cours LEPL1103 (partie EDP) de l'[EPL] ([UCLouvain]) pour la visualisation de solutions d'équations aux dérivées partielles.

## Contenu
- [Fonctionnalités](#fonctionnalités)
- [Installation](#installation)
- [Installer octave](#installer-octave)
- [Limitations et bugs connus](#limitations-et-bugs-connus)

<br>

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

<br>

## Installation
Si vous ne possèdez pas octave (version 6.1), veuillez consulter la section [installer octave](#installer-octave).

### 1. Télécharger le dossier principal
Il suffit juste de cliquer sur le bouton **Code** du répertoire principal [EDP_Octave](https://github.com/Reshims/EDP_Octave).

<details>
  <summary>Image d'aide</summary>
    
  > ![img](https://i.imgur.com/ulzWdjj.gif)
</details>

### 2. Décompresser le fichier
Vous devriez obtenir un dossier contenant tous les fichiers/dossiers du répertoire principal.  
**Si ce n'est pas le cas**, essayez de télécharger une nouvelle fois le dossier.

### 3. Changer le chemin dans octave
Le programme nécessitant des dépendances, octave doit **impérativement** lancer le programme depuis son dossier source.
Pour ce faire, il suffit de vous déplacer jusqu'au dossier comprenant **main.m** ainsi que ses dépendances via le navigateur
intégré d'octave.

<details>
  <summary>Image d'aide</summary>
    
  > ![img](https://i.imgur.com/q47aWoo.gif)
</details>

### 4. Lancer 'main.m'
Une fois le bon dossier ouvert, double-cliquez sur **main.m** pour l'ouvrir dans l'éditeur d'octave.  
Pour lancer le programme, appuyez sur **F5** ou sur le bouton **Enregistrer le Script et l'Exécuter / Continuer** ![img](https://i.imgur.com/HsPopqJ.png)

<details>
  <summary>Après quelques instants, une nouvelle fenêtre devrait se lancer: le programme a démarré !</summary>
    
  > ![img](https://i.imgur.com/kfuSF7P.png)
</details>

<br>

## Installer octave
Dans le cas où vous ne possédez pas encore ce language nécessaire au fonctionnement du programme,
vous pouvez l'installer en le téléchargeant depuis [son site](https://www.gnu.org/software/octave/index).

:exclamation: Octave nécessite ~1.7Go d'espace

### Téléchargement
Vous pouvez télécharger la dernière version d'octave [ici](https://www.gnu.org/software/octave/download.html)
ou chercher une version précise [ici](https://ftp.gnu.org/gnu/octave/).

<details>
  <summary>Image d'aide</summary>
  
  > ![img](https://i.imgur.com/HLF2sMp.png)
</details>

### Installation
> Ces prochaines sections ne traiteront que de la version Windows car je n'ai pas eu la chance de pouvoir tenter une installation sous macOS.

**Si vous avez choisi l'"installer" (.exe)**, il vous suffit de lancer le fichier téléchargé et l'utilitaire d'installation s'occupera de tout.  
Il est conseillé de créer des raccourcis bureau quand ils vous seront proposés.

**Si vous avez choisis l'archive (.7z/.zip)**, il vous suffit d'extraire les fichiers de l'archive et octave sera prêt à l'emploi.

### Lancement
**Si vous avez les raccourcis bureau**, il vous suffit de lancer la version **GUI** d'Octave.

L'executable pour lancer Octave se trouve dans le dossier principal et se nomme **octave.vbs**  
Il se lance comme n'importe quel programme en **.exe**.

### Avancé
Pour lancer octave depuis le terminal via la commande `octave`, il vous suffit d'ajouter le chemin "../octave/mingw64/bin" au **PATH**.
"../octave" correspond au dossier contenant **octave.vbs**.

Vous pourrez alors lancer un fichier via la commande `octave path_to_file/file.m`.  
Un argument peut y être rajouté pour changer l'exécution d'octave:
  * `--no-gui`: lancer octave en mode terminal.
  * `--gui`: lancer octave avec l'interface graphique.
  
Si aucun fichier n'est précisé, octave se lancera dans le mode précisé.

Lancer en utilisant la commande `octave` peut résulter en des bugs graphiques,
préférez lancer le fichier **octave-gui.exe** présent dans le chemin "../octave/mingw64/bin".

<br>

## Limitations et bugs connus
### Interface graphique
> Le chargement des éléments UI est relativement lent.

C'est une limitation due à la fois à octave et aussi à mon manque d'expérience.  
Mettre sa souris sur la fenêtre permet d'accélérer l'affichage.

> Certains éléments son modifiables et n'ont pas toujours la bonne forme.

C'est une limitation d'octave et n'ayant pas une grande importance quant à la stabilité du programme,  
il est conseillé d'éviter de modifier ce qui n'est pas prévu à cet effet.

### Simulation
> Il n'y a pas beaucoup de simulations différentes.

Cette version du programme est orientée dans l'application directe des formules vues au cours LEPL1103.
Les algorithmes de résolution sont donc des implémentations presque naïves des résultats optenus en cours magistraux.

> Les simulations sont longues à charger.

Comme dit au point précédant, les algorithmes ne sont pas assez optimisés.
Ils le seront peut-être plus dans une version ultérieure.

> L'utilisation de la RAM est anormale.

Les matrices de solution sont malheureusement assez grandes. La mémoire utilisée est donc relativement grande.  
De plus, à cause d'un bug lié à l'utilisation d'interface graphique, certaines variables (notamment celles de solution...)
deviennent persistantes et donc, impossibles à supprimer de la RAM sans redémarrage complet d'octave.

Si vous utilisez le programme via l'interface graphique d'octave, veuillez redémarrer l'interface entre les utilisations et
évitez de lancer trop de simulations sur une seule utilisation.

[EPL]: https://uclouvain.be/fr/facultes/epl
[UCLouvain]: https://uclouvain.be/fr/index.html
