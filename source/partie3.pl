/************
 * Partie 3 *
 ************/
:- [partie2].

troisieme_etape(Abi,Abr) :-
    tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),
    nl,write('Lie: '),print(Lie),
    nl,write('Lpt: '),print(Lpt),
    nl,write('Li: '),print(Li),
    nl,write('Lu: '),print(Lu),
    nl,write('Ls: '),print(Ls),
    %resolution(Lie,Lpt,Li,Lu,Ls,Abr), 
    nl,write('Youpiiiiii, on a demontre laproposition initiale !!!'),
    nl.

tri_Abox([],[],[],[],[],[]).
tri_Abox([(I,some(R,C))|AbiQ],[(I,some(R,C))|Lie],Lpt,Li,Lu,Ls) :-
    tri_Abox(AbiQ,Lie,Lpt,Li,Lu,Ls),
    !.
tri_Abox([(I,all(R,C))|AbiQ],Lie,[(I,all(R,C))|Lpt],Li,Lu,Ls) :-
    tri_Abox(AbiQ,Lie,Lpt,Li,Lu,Ls),
    !.
tri_Abox([(I,and(C1,C2))|AbiQ],Lie,Lpt,[(I,and(C1,C2))|Li],Lu,Ls) :-
    tri_Abox(AbiQ,Lie,Lpt,Li,Lu,Ls),
    !.
tri_Abox([(I,or(C1,C2))|AbiQ],Lie,Lpt,Li,[(I,or(C1,C2))|Lu],Ls) :-
    tri_Abox(AbiQ,Lie,Lpt,Li,Lu,Ls),
    !.
tri_Abox([(I,not(C))|AbiQ],Lie,Lpt,Li,Lu,[(I,not(C))|Ls]) :-
    cnamea(C),
    tri_Abox(AbiQ,Lie,Lpt,Li,Lu,Ls),
    !.
tri_Abox([(I,C)|AbiQ],Lie,Lpt,Li,Lu,[(I,C)|Ls]) :-
    cnamea(C),
    tri_Abox(AbiQ,Lie,Lpt,Li,Lu,Ls),
    !.