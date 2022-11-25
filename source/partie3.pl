/************
 * Partie 3 *
 ************/
:- [partie2].

troisieme_etape(Abi,Abr) :-
    tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),
    nl,write('ABox etendu --------------------------------'),nl,
    affiche_Abox(Ls,Lie,Lpt,Li,Lu,Abr),
    resolution(Lie,Lpt,Li,Lu,Ls,Abr),
    nl,write('Youpiiiiii, on a demontre la proposition initiale !!!'),
    nl.

infixe(not(C),T) :-
    infixe(C,CT),
    atom_concat('\u00ac',CT,T),
    !.
infixe(and(C1,C2),T) :-
    infixe(C1,CT1),
    infixe(C2,CT2),
    atom_concat(CT1,'\u2293',T1),
    atom_concat(T1,CT2,T2),
    atom_concat('(',T2,T3),
    atom_concat(T3,')',T),
    !.
infixe(or(C1,C2),T) :-
    infixe(C1,CT1),
    infixe(C2,CT2),
    atom_concat(CT1,'\u2294',T1),
    atom_concat(T1,CT2,T2),
    atom_concat('(',T2,T3),
    atom_concat(T3,')',T),
    !.
infixe(some(R,C),T) :-
    infixe(R,RT),
    infixe(C,CT),
    atom_concat('\u2200',RT,T1),
    atom_concat(T1,'.',T2),
    atom_concat(T2,CT,T),
    !.
infixe(all(R,C),T) :-
    infixe(R,RT),
    infixe(C,CT),
    atom_concat('\u2203',RT,T1),
    atom_concat(T1,'.',T2),
    atom_concat(T2,CT,T),
    !.
infixe(anything,'\u22a4').
infixe(nothing,'\u22a5').
infixe(C,T) :-
    atom_string(C,T).

formatassertion((I1,I2,R),T) :-
    atom_string(I1,IT1),
    atom_string(I2,IT2),
    atom_string(R,RT),
    atom_concat('<',IT1,T1),
    atom_concat(T1,',',T2),
    atom_concat(T2,IT2,T3),
    atom_concat(T3,'>',T4),
    atom_concat(T4,':',T5),
    atom_concat(T5,RT,T),
    !.
formatassertion((I,C),T) :-
    infixe(C,CT),
    atom_string(I,IT),
    atom_concat(IT,':',T1),
    atom_concat(T1,CT,T),
    !.


writeabi([]).
writeabi([(I,C)]) :-
    formatassertion((I,C),T),
    write(T),
    !.
writeabi([(I,C)|AbiQ]) :-
    formatassertion((I,C),T),
    write(T),
    write(', '),
    writeabi(AbiQ),
    !.

writeabr([]).
writeabr([(I1,I2,R)]) :-
    formatassertion((I1,I2,R),T),
    write(T),
    !.
writeabr([(I1,I2,R)|AbrQ]) :-
    formatassertion((I1,I2,R),T),
    write(T),
    write(', '),
    writeabi(AbrQ),
    !.

writeliste([]) :-
    write('[]'),
    !.
writeliste(Abi) :-
    Abi = [(_,_)|_],
    writeabi(Abi),
    !.
writeliste(Abr) :-
    Abr = [(_,_,_)|_],
    writeabr(Abr),
    !.

affiche_Abox(Ls, Lie, Lpt, Li, Lu, Abr) :-
    write('\t'),write('Ls (I:C) = '), writeliste(Ls),nl,
    write('\t'),write('Lie (a:\u2200R.C) = '), writeliste(Lie),nl,
    write('\t'),write('Lpt (a:\u2203R.C) = '), writeliste(Lpt),nl,
    write('\t'),write('Li (a:C\u2293D) = '), writeliste(Li),nl,
    write('\t'),write('Lu (a:C\u2294D) = '), writeliste(Lu),nl,
    write('\t'),write('Abr (<a,b>:R) = '), writeliste(Abr).

affiche_evolution_Abox(Ls1, Lie1, Lpt1, Li1, Lu1, Abr1, Ls2, Lie2, Lpt2, Li2, Lu2, Abr2) :-
    write('--------------------------------'),nl,
    write('ABox initiale : '),nl,
    affiche_Abox(Ls1, Lie1, Lpt1, Li1, Lu1, Abr1),
    nl,write('ABox evoluee : '),nl,
    affiche_Abox(Ls2, Lie2, Lpt2, Li2, Lu2, Abr2).

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
    nl,write('Regle \u2200 '),
    affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, NewAbr),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1], Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,NewAbr).

transformation_and(Lie,Lpt,Li,Lu,Ls,Abr) :-
    enleve((I,and(C1,C2)),Li,NewLi),
    evolue([(I,C1),(I,C2)], Lie, Lpt, NewLi, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    nl,write('Regle \u2293 '),
    affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr),
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
    nl,write('Regle \u2203 '),
    evolue(AllInst, Lie, NewLpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1],Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).

transformation_or(Lie,Lpt,Li,Lu,Ls,Abr) :- % Premier noeud
    enleve((I,or(C,_)), Lu, NewLu),
    evolue((I,C),Lie, Lpt, Li, NewLu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    nl,write('Regle \u2294 1 '),
    affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1], Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).
transformation_or(Lie,Lpt,Li,Lu,Ls,Abr) :- % Deuxième noeud
    enleve((I,or(_,C)), Lu, NewLu),
    evolue((I,C),Lie, Lpt, Li, NewLu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1),
    nl,write('Regle \u2294 2 '),
    affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr),
    flatten([Lie1, Lpt1, Li1, Lu1, Ls1], Abi1),
    testclash(Abi1),
    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).

resolution([],[],[],[],Ls,_) :-
    member(_,Ls),
    not(testclash(Ls)),
    nl, write("Echec de la resolution !").
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
   