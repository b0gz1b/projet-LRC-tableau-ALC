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
    evolue((david,some(aEdite,sculpture)), Lie, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    nl,write('Lie1: '),print(Lie1),
    nl,write('Lpt1: '),print(Lpt1),
    nl,write('Li1: '),print(Li1),
    nl,write('Lu1: '),print(Lu1),
    nl,write('Ls1: '),print(Ls1),
    %resolution(Lie,Lpt,Li,Lu,Ls,Abr),
    nl,write('Youpiiiiii, on a demontre laproposition initiale !!!'),
    nl.
/*
Tri de la ABox étendue
 */
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


evolue((I,some(R,C)), Lie, Lpt, Li, Lu, Ls, [(I,some(R,C))|Lie], Lpt, Li, Lu, Ls).
evolue((I,all(R,C)), Lie, Lpt, Li, Lu, Ls, Lie, [(I,all(R,C))|Lpt], Li, Lu, Ls).
evolue((I,and(C1,C2)), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, [(I,and(C1,C2))|Li], Lu, Ls).
evolue((I,or(C1,C2)), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li, [(I,or(C1,C2))|Lu], Ls).
evolue((I,not(C)), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li, Lu, [(I,not(C))|Ls]).
evolue((I,C), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li, Lu, [(I,C)|Ls]).

%% complete_some(Lie,Lpt,Li,Lu,Ls,Abr) :-
    %% genere(B),
