# projet-LRC-tableau-ALC

Ecriture en Prolog d’un démonstrateur basé sur l’algorithme des tableaux pour la logique de description ALC dans le cadre de l'UE de LRC.

# Utilisation

Executer le fichier `run.pl` lancera le programme et l'interpreteur.
Le prédicat programme est définit dans `load.pl` il est à modifier au fur et à mesure du projet, pour l'instant il affiche le résultat de la partie 1.

# Prédicats à réaliser

1. Etape préliminaire de vérification et de mise en forme de la Tbox et de la Abox
	* autoref : Fait
	* concept : Fait
	* traitement_Tbox : Fait
	* traitement_Abox : Fait
2. Saisie de la proposition à démontrer
	* acquisition_prop_type1 : Fait
	* acquisition_prop_type2 : Fait
3. Démonstration de la proposition
	* tri_Abox : À faire
	* resolution : À faire
	* complete_some(Lie,Lpt,Li,Lu,Ls,Abr) : À faire
	* transformation_and : À faire
	* deduction_all : À faire
	* transformation_or : À faire
	* evolue : À faire
	* affiche_evolution_Abox : À faire