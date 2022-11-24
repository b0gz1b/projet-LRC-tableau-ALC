/************
 * Partie 3 *
 ************/
:- [partie2].

troisieme_etape(Abi,Abr) :-
    tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),
    resolution(Lie,Lpt,Li,Lu,Ls,Abr),
    nl,write('Youpiiiiii, on a demontre la proposition initiale !!!'),
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

/*
Permet l'ajout sans répétition
 */
add_to_set(E,S1,S2) :- list_to_set([E|S1],S2).

evolue([], Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li, Lu, Ls).
evolue([E|Q], Lie, Lpt, Li, Lu, Ls, Lie2, Lpt2, Li2, Lu2, Ls2) :-
    evolue(E, Lie, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    evolue(Q, Lie1, Lpt1, Li1, Lu1, Ls1, Lie2, Lpt2, Li2, Lu2, Ls2),
    !.
evolue((I,some(R,C)), Lie, Lpt, Li, Lu, Ls, Lie1, Lpt, Li, Lu, Ls) :-
    add_to_set((I,some(R,C)), Lie, Lie1),
    !.
evolue((I,all(R,C)), Lie, Lpt, Li, Lu, Ls, Lie, Lpt1, Li, Lu, Ls) :-
    add_to_set((I,all(R,C)), Lpt, Lpt1),
    !.
evolue((I,and(C1,C2)), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li1, Lu, Ls) :-
    add_to_set((I,and(C1,C2)), Li, Li1),
    !.
evolue((I,or(C1,C2)), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li, Lu1, Ls) :-
    add_to_set((I,or(C1,C2)), Lu, Lu1),
    !.
evolue((I,E), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li, Lu, Ls1) :-
    add_to_set((I,E), Ls, Ls1),
    !.

testclash(Abi) :-
    testclash(Abi,Abi).
testclash([],_).
testclash([(I,C)|Q],Abi) :-
    nonmember((I,not(C)),Abi),
    testclash(Q,Abi).

complete_some(Lie,Lpt,Li,Lu,Ls,Abr) :-
    enleve((I,some(R,C)),Lie,NewLie),
    genere(B),
    evolue((B,C), NewLie, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    concat((I,B,R),Abr,NewAbr),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1], Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,NewAbr).

transformation_and(Lie,Lpt,Li,Lu,Ls,Abr) :-
    enleve((I,and(C1,C2)),Li,NewLi),
    evolue([(I,C1),(I,C2)], Lie, Lpt, NewLi, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1], Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).

/*
Récupère toute les déductions possibles
 */
allinstances(_,[],[]).
allinstances((A,R,C),[(A,Y,R)|AbrQ],[(Y,C)|AllInst]) :-
    allinstances((A,R,C),AbrQ,AllInst),
    !.
allinstances((A,R,C),[_|AbrQ],AllInst) :-
    allinstances((A,R,C),AbrQ,AllInst),
    !.

deduction_all(Lie,Lpt,Li,Lu,Ls,Abr) :-
    enleve((A,all(R,C)),Lpt,NewLpt),
    member((A,_,R), Abr),
    allinstances((A,R,C),Abr,AllInst),
    evolue(AllInst, Lie, NewLpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1],Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).

transformation_or(Lie,Lpt,Li,Lu,Ls,Abr) :- % Premier noeud
    enleve((I,or(C,_)), Lu, NewLu),
    evolue((I,C),Lie, Lpt, Li, NewLu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1], Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).
transformation_or(Lie,Lpt,Li,Lu,Ls,Abr) :- % Deuxième noeud
    enleve((I,or(_,C)), Lu, NewLu),
    evolue((I,C),Lie, Lpt, Li, NewLu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1], Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).

resolution([],[],[],[],Ls,_) :-
    member(_,Ls),
    testclash(Ls),
    nl, write("Echec de la resolution !"),
    fail,
    !.
resolution(Lie,Lpt,Li,Lu,Ls,Abr) :-
    member(_,Lie),
    complete_some(Lie,Lpt,Li,Lu,Ls,Abr).
resolution(Lie,Lpt,Li,Lu,Ls,Abr) :-
    member(_,Lpt),
    deduction_all(Lie,Lpt,Li,Lu,Ls,Abr).
resolution(Lie,Lpt,Li,Lu,Ls,Abr) :-
    member(_,Li),
    transformation_and(Lie,Lpt,Li,Lu,Ls,Abr).
resolution(Lie,Lpt,Li,Lu,Ls,Abr) :-
    member(_,Lu),
    transformation_or(Lie,Lpt,Li,Lu,Ls,Abr).

%% affiche_evolution_Abox(Ls1, Lie1, Lpt1, Li1, Lu1, Abr1, Ls2, Lie2, Lpt2, Li2, Lu2, Abr2) :-
%%     