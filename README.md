# EDP_Octave

Une application du cours LEPL1103 (partie EDP) de l'[EPL] ([UCLouvain]) pour la visualisation de solutions d'équations aux dérivées partielles.

## Contenu

- [Fonctionnalités](#features)

<a name="features"><a/>
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

|![example LR](https://i.imgur.com/OLkfVoc.gif)|![example LC](https://i.imgur.com/3BlScKR.gif)|
|:---:|:---:|
|Example de domaine rectangulaire|Example de domaine circulaire|

### Équation d'onde
Résoud l'équation d'onde ![eq](https://i.imgur.com/RDzBxxG.png) pour un domaine rectangulaire.  
On autorise ici que deux conditions limite: une condition de Direchlet et une de Neumann en t = 0.  
Comme l'équation est à 3 dimensions (2 spatiales et 1 temporelle), on peut choisir de montrer la solution à un temps donné ou de l'animer pour un intervalle donné.

|![example WS](https://i.imgur.com/nJYkIan.gif)|![example WA](https://i.imgur.com/7v92RKb.gif)|
|:---:|:---:|
|Example de solution pour un temps unique|Example de solution animée sur un intervalle de temps|

[EPL]: https://uclouvain.be/fr/facultes/epl
[UCLouvain]: https://uclouvain.be/fr/index.html
