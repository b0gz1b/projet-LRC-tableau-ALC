/**
 * Charge les fichiers et définit le prédicat programme
 */
:- use_module(library(theme/dark)).
:- encoding(utf8).

:- [partie1].
programme :- 
	premiere_etape(Tbox,Abi,Abr),
	write('T-Box : '),print(Tbox),
	nl,write('A-Box concepts: '),print(Abi),
	nl,write('T-Box rôles: '),print(Abr),
	nl.
