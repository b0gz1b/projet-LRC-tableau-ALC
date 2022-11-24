/**
 * Charge les fichiers et définit le prédicat programme
 */
:- use_module(library(theme/dark)).
:- encoding(utf8).

:- [source/partie1,
	source/partie2,
	source/partie3].

/*
programme/0
Lance le programme
*/
programme :- 
	premiere_etape(Tbox,Abi,Abr),
	deuxieme_etape(Abi,Abi1,Tbox),
	troisieme_etape(Abi1,Abr).