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
	write('T-Box : '),print(Tbox),
	nl,write('A-Box concepts: '),print(Abi),
	nl,write('T-Box roles: '),print(Abr),
	nl,
	deuxieme_etape(Abi,Abi1,Tbox),
	nl,write('A-Box concepts mise a jour: '),print(Abi1),
	nl,
	troisieme_etape(Abi1,Abr).