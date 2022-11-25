# projet-LRC-tableau-ALC

Ecriture en Prolog d’un démonstrateur basé sur l’algorithme des tableaux pour la logique de description ALC dans le cadre de l'UE de LRC.

# Utilisation

Executer le fichier `run.pl` lancera le programme et l'interpreteur.
Le prédicat programme est définit dans `load.pl`.

# Prédicats à réaliser

## I. Etape préliminaire de vérification et de mise en forme de la Tbox et de la Abox
- [X] autoref
- [X] concept
- [X] traitement_Tbox
- [X] traitement_Abox

## II. Saisie de la proposition à démontrer
- [X] acquisition_prop_type1
- [X] acquisition_prop_type2

## III. Démonstration de la proposition
- [X] tri_Abox
- [X] resolution
- [X] complete_some(Lie,Lpt,Li,Lu,Ls,Abr)
- [X] transformation_and
- [X] deduction_all
- [X] transformation_or
- [X] evolue
- [X] affiche_evolution_Abox

## TODO LIST

- [ ] écrire le rapport
- [ ] faire un jeu de test pour résolution
- [ ] changer l'implémentation de l'affichage avec celle que tu m'a envoyé