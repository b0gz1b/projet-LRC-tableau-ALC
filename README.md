## projet-LRC-tableau-ALC

Ecriture en Prolog d’un démonstrateur basé sur l’algorithme des tableaux pour la logique de description ALC dans le cadre de l'UE de LRC.

## Utilisation

Executer le fichier `run.pl` lancera le programme et l'interpreteur.
Le prédicat programme est définit dans `load.pl` il est à modifier au fur et à mesure du projet, pour l'instant il affiche le résultat de la partie 1.

## Prédicats à réaliser

# I. Etape préliminaire de vérification et de mise en forme de la Tbox et de la Abox
	-[x] autoref
	-[x] concept
	-[x] traitement_Tbox
	-[x] traitement_Abox
# II. Saisie de la proposition à démontrer
	-[x] acquisition_prop_type1
	-[x] acquisition_prop_type2
# III. Démonstration de la proposition
	-[x] tri_Abox
	-[x] resolution
	-[x] complete_some(Lie,Lpt,Li,Lu,Ls,Abr)
	-[x] transformation_and
	-[x] deduction_all
	-[x] transformation_or
	-[x] evolue
	-[x] affiche_evolution_Abox

## TODO LIST

-[ ] écrire le rapport
-[ ] faire un jeu de test pour résolution
-[ ] changer l'implémentation de l'affichage avec celle que tu m'a envoyé