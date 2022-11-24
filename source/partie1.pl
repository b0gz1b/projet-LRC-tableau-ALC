/************
 * Partie 1 *
 ************/
:-[utils].
/* Tbox et Abox de l'exo 3 du TD4 */
equiv(sculpteur,and(personne,some(aCree,sculpture))).
equiv(auteur,and(personne,some(aEcrit,livre))).
equiv(editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))).
equiv(parent,and(personne,some(aEnfant,anything))).
cnamea(personne).
cnamea(livre).
cnamea(objet).
cnamea(anything).
cnamea(nothing).
cnamea(sculpture).
cnamena(auteur).
cnamena(editeur).
cnamena(sculpteur).
cnamena(parent).
iname(michelAnge).
iname(david).
iname(sonnets).
iname(vinci).
iname(joconde).
rname(aCree).
rname(aEcrit).
rname(aEdite).
rname(aEnfant).
inst(michelAnge,personne).
inst(david,sculpture).
inst(sonnets,livre).
inst(vinci,personne).
inst(joconde,objet).
instR(michelAnge, david, aCree).
instR(michelAnge, sonnets, aEcrit).
instR(vinci, joconde, aCree).

/* 
role/1: R=Role
Vérifie l'appartenance de R aux roles
*/
role(R) :-
    setof(X, rname(X),L), % Liste des roles
    member(R,L),
    !.
/* 
instance/1: I=Instance
Vérifie l'appartenance de Instance aux instances
*/
instance(I) :-
    setof(X, iname(X),L), % Liste des instances
    member(I,L),
    !.

/*
concept/1: C=Expression
Vérifie que C est correcte et que tout ses termes atomiques sont des concepts
*/
concept(C) :-
    setof(X, cnamea(X),Lca), % Liste des concepts atomiques
    member(C,Lca), % C1 doit être un concept atomique
    !.
concept(C) :-
    setof(X, cnamena(X),Lcc), % Liste des concepts complexes
    member(C,Lcc), % C1 doit être un concept complexe
    !.
concept(not(C)) :- % Récurrence sur les expressions correctes (not,and,or,some,all)
    concept(C),
    !.
concept(and(C1,C2)) :-
    concept(C1),
    concept(C2),
    !.
concept(or(C1,C2)) :-
    concept(C1),
    concept(C2),
    !.
concept(some(R,C1)) :-
    role(R),
    concept(C1),
    !.
concept(all(R,C1)) :-
    role(R),
    concept(C1),
    !.

/* 
pautoref/6: C=Concept, DefC=Expression, TBox=Liste[(Concept,Expression), 
            Lcc=Liste[Concept], Lca=Liste[Concept], Lcr=Liste[Concept]
Vérifie que C de définition conceptuelle DefC équivalente dans la TBox ne s'auto-référence pas.
C'est à dire qu'en remplaçant les concepts complexes (ceux dans Lcc) de DefC récursivement
on ne retombe que sur des concepts atomique (ceux de Lca) ou des concepts complexes différents
de C (Lcr).
Remarque: Ce prédicat ne vaut faux QUE si le concept s'auto-référence, autrement dit si A référence B
qui référence C qui référence B, A ne s'auto-référence pas donc le prédicat vaut vrai pour A.
Inversement pour B et C le prédicat vaudra faux.
*/
pautoref(_,DefC,_,_,Lca,_) :-
    member(DefC,Lca), % La définition est un concept atomique
    !.
pautoref(C,not(DefC),TBox,Lcc,Lca,Lcr) :-
    pautoref(C,DefC,TBox,Lcc,Lca,Lcr), /* Récurrence sur les expressions 
                                          correctes (not,and,or,some,all) */
    !.
pautoref(C,and(DefC1,DefC2),TBox,Lcc,Lca,Lcr) :-
    pautoref(C,DefC1,TBox,Lcc,Lca,Lcr),
    pautoref(C,DefC2,TBox,Lcc,Lca,Lcr),
    !.
pautoref(C,or(DefC1,DefC2),TBox,Lcc,Lca,Lcr) :-
    pautoref(C,DefC1,TBox,Lcc,Lca,Lcr),
    pautoref(C,DefC2,TBox,Lcc,Lca,Lcr),
    !.
pautoref(C,some(_,DefC),TBox,Lcc,Lca,Lcr) :-
    pautoref(C,DefC,TBox,Lcc,Lca,Lcr),
    !.
pautoref(C,all(_,DefC),TBox,Lcc,Lca,Lcr) :-
    pautoref(C,DefC,TBox,Lcc,Lca,Lcr),
    !.
pautoref(C,DefC,_,Lcc,_,Lcr):-
    member(DefC,Lcc), % La définition est un concept complexe
    C\==DefC, % C ne se référence pas
    member(DefC,Lcr), % On est tombé dans un cycle qui n'inclut pas C (voir Remarque)
    !.
pautoref(C,DefC,TBox,Lcc,Lca,Lcr):-
    member(DefC,Lcc), % La définition est un concept complexe
    nonmember(DefC,Lcr), % La définition est un concept complexe nouveau
    C\==DefC, % C ne se référence pas
    member((DefC,DDefC),TBox), % DDefC est la définition de la définition dans la TBox
    pautoref(C,DDefC,TBox,Lcc,Lca,[DefC|Lcr]), /* On remplace DefC par sa définition
                                                  équivalente dans la TBox et on l'ajoute
                                                  à la liste des concepts complexes rencontrés*/
    !.   

/*
Jeu de tests:
:-pautoref(
    sculpture,
    and(objet,all(creePar,sculpteur)),
    [
        (sculpteur,and(personne,some(aCree,sculpture))),
        (auteur,and(personne,some(aEcrit,livre))),
        (editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))),
        (parent,and(personne,some(aEnfant,anything))),
        (sculpture,and(objet,all(creePar,sculpteur)))
    ],
    [sculpture,auteur,editeur,sculpteur,parent],
    [personne,objet,livre,anything,nothing],
    []
).
false.

:-pautoref(
    sculpture,
    and(objet,all(creePar,personne)),
    [
        (sculpteur,and(personne,some(aCree,sculpture))),
        (auteur,and(personne,some(aEcrit,livre))),
        (editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))),
        (parent,and(personne,some(aEnfant,anything))),
        (sculpture,and(objet,all(creePar,personne)))
    ],
    [sculpture,auteur,editeur,sculpteur,parent],
    [personne,objet,livre,anything,nothing],
    []
).
true.

:-pautoref(
    sculpture,
    and(objet,all(creePar,editeur)),
    [
        (sculpteur,and(personne,some(aCree,sculpture))),
        (auteur,and(personne,some(aEcrit,livre))),
        (editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))),
        (parent,and(personne,some(aEnfant,anything))),
        (sculpture,and(objet,all(creePar,personne)))
    ],
    [sculpture,auteur,editeur,sculpteur,parent],
    [personne,objet,livre,anything,nothing],
    []
).
true.

:-pautoref(
    editeur,
    and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre))),
    [
        (sculpteur,and(personne,some(aCree,sculpture))),
        (auteur,and(personne,some(aEcrit,livre))),
        (editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))),
        (parent,and(personne,some(aEnfant,anything)))
    ],
    [auteur,editeur,sculpteur,parent],
    [sculpture,personne,objet,livre,anything,nothing],
    []
).
true.

:-pautoref(a,b,[(a,b),(b,c),(c,b),(d,e)],[a,b,c,d],[e],[]).
true. (le cycle est a-b-c-b-c-... donc a ne s'auto-reference pas)

:-pautoref(b,c,[(a,b),(b,c),(c,b),(d,e)],[a,b,c,d],[e],[]).
false. (le cycle est b-c-b-c-... b ne s'auto-reference)

:-pautoref(a,b,[(a,b),(b,a),(c,b),(d,e)],[a,b,c,d],[e],[]).
false.

:-pautoref(a,not(b),[(a,not(b)),(b,c),(c,b),(d,e)],[a,b,c,d],[e],[]).
true.

:-pautoref(a,not(b),[(a,not(b)),(b,c),(d,e)],[a,b,d],[c,e],[]).
true.

:-pautoref(a,and(e,not(b)),[(a,and(e,not(b))),(b,c),(d,e)],[a,b,d],[c,e],[]).
true.

:-pautoref(a,and(e,not(b)),[(a,and(e,not(b))),(b,c),(c,b),(d,e)],[a,b,c,d],[e],[]).
true.
*/

/*--- Traitement de la T-Box ---*/

/*
tboxcor/1: TBox=Liste[(Concept,Expression)]
Vérifie que la TBox est composé de concepts et qu'elle comprend les concepts ⊤ et ⊥
*/
tboxcor([]) :-
    concept(nothing),
    concept(anything),
    !.
tboxcor([(C,EC)|Q]) :-
    concept(C),
    concept(EC),
    tboxcor(Q),
    !.

/*
tboxac/2: Q=Liste[(Concept,Expression)],TBox=Liste[(Concept,Expression)]
Vérifie que la TBox est acyclique en testant l'auto-référence de toutes ses définitions
*/
tboxac([],_).
tboxac([C|Q],TBox) :-
    member((C,EC),TBox), % EC est l'expression conceptuelle équivalente à C dans la TBox
    setof(X,cnamena(X),Lcc), % Liste des concepts complexes
    setof(X,cnamea(X),Lca), % Liste des concepts atomiques
    pautoref(C,EC,TBox,Lcc,Lca,[]), 
    tboxac(Q,TBox). % Récurrence

/*
tboxcorac/1: TBox=Liste[(Concept,Expression)]
Vérifie que la TBox est correcte et acyclique
*/
tboxcorac(TBox) :-
    tboxcor(TBox),
    setof(X,cnamena(X),Lcc),
    tboxac(Lcc,TBox),
    !.

/* 
remplacecomplexe/5: DefC=Expression, TBox=Liste[(Concept,Expression)],
                    Lcc=Liste[Concept], Lca=Liste[Concept], DefCT=Expression
Renvoie dans DefCT la définition DefC dont tout les concepts complexes (ceux dans Lcc) 
ont été remplacés par leur expression conceptuelle equivalente dans la TBox et ce 
récursivement de sorte à ce que tout les concepts de DefCT soient atomiques (dans Lca)
*/
remplacecomplexe(not(DefC),TBox,Lcc,Lca,not(DefCT)) :-
    remplacecomplexe(DefC,TBox,Lcc,Lca,DefCT),/* Récurrence sur les expressions 
                                                 correctes (not,and,or,some,all) */
    !.
remplacecomplexe(and(DefC1,DefC2),TBox,Lcc,Lca,and(DefCT1,DefCT2)) :-
    remplacecomplexe(DefC1,TBox,Lcc,Lca,DefCT1),
    remplacecomplexe(DefC2,TBox,Lcc,Lca,DefCT2),
    !.
remplacecomplexe(or(DefC1,DefC2),TBox,Lcc,Lca,or(DefCT1,DefCT2)) :-
    remplacecomplexe(DefC1,TBox,Lcc,Lca,DefCT1),
    remplacecomplexe(DefC2,TBox,Lcc,Lca,DefCT2),
    !.
remplacecomplexe(some(R,DefC),TBox,Lcc,Lca,some(R,DefCT)) :-
    remplacecomplexe(DefC,TBox,Lcc,Lca,DefCT),
    !.
remplacecomplexe(all(R,DefC),TBox,Lcc,Lca,all(R,DefCT)) :-
    remplacecomplexe(DefC,TBox,Lcc,Lca,DefCT),
    !.
remplacecomplexe(DefC,_,_,Lca,DefC) :-
    member(DefC,Lca), % DefC est atomique
    !.
remplacecomplexe(DefC,TBox,Lcc,Lca,DefCT) :-
    member(DefC,Lcc), % DefC est complexe
    member((DefC,DDefC),TBox), % DDefC est la définition équivalent à DefC dans la TBox
    remplacecomplexe(DDefC,TBox,Lcc,Lca,DefCT),
    !.

/* 
tboxs/5 : Q=Liste[(Concept,Expression)], TBox=Liste[(Concept,Expression)], 
          Lcc=Liste[Concept], Lca=Liste[Concept], TBoxS=Liste[(Concept,Expression)]
Renvoie dans TBoxS la TBox simplifiée dans laquelle on a remplacé les définitions avec des
concepts complexes par leur définition équivalente jusqu'à n'avoir que des concepts atomiques
*/
tboxs([],_,_,_,[]).
tboxs([(C,EC)|Q],TBox,Lcc,Lca,[(C,S)|TBoxS]) :-
    remplacecomplexe(EC,TBox,Lcc,Lca,S), % S contient la définition simplifiée
    tboxs(Q,TBox,Lcc,Lca,TBoxS),
    !.

/* 
tboxnnf/2 : TBox=Liste[(Concept,Expression)], TBoxNNF=Liste[(Concept,Expression)], 
Renvoie dans TBoxNNF la TBox mise sous FNN
*/
tboxnnf([],[]).
tboxnnf([(C,EC)|Q],[(C,NNFEC)|TBOXNNF]) :-
    nnf(EC,NNFEC),
    tboxnnf(Q,TBOXNNF),
    !.
/*
tboxnnf/2 : TBox=Liste[(Concept,Expression)], TBoxT=Liste[(Concept,Expression)], 
Vérifie que la TBox est correcte et acyclique, la simplifie puis la met en FNN dans TBoxT
*/
traitement_TBox(TBox,TBoxT) :-
    tboxcorac(TBox),
    setof(X,cnamena(X),Lcc),
    setof(X,cnamea(X),Lca),
    tboxs(TBox,TBox,Lcc,Lca,TBoxS),
    tboxnnf(TBoxS,TBoxT),
    !.

/*--- Traitement de la A-Box ---*/

/*
aboxCcor/1: ABoxC=Liste[(Instance,Concept)]
Vérifie que la ABox des concepts est correcte
*/
aboxCcor([]).
aboxCcor([(I,C)|Q]) :-
    instance(I),
    concept(C),
    aboxCcor(Q),
    !.

/*
aboxRcor/1: ABoxR=Liste[(Instance,,Instance,Role)]
Vérifie que la ABox des rôles est correcte
*/
aboxRcor([]).
aboxRcor([(I1,I2,R)|Q]) :-
    instance(I1),
    instance(I2),
    role(R),
    aboxRcor(Q),
    !.

/*
aboxcor/1: ABox=[Liste[(Instance,Concept)], Liste[(Instance,,Instance,Role)]]
Vérifie que la ABox est correcte
*/
aboxcor([ABoxC,ABoxR]) :-
    aboxCcor(ABoxC),
    aboxRcor(ABoxR),
    !.

/*
aboxcs/3: ABoxC=Liste[(Instance,Concept)], TBox=Liste[(Concept,Expression)],
          ABoxCS=Liste[(Instance,Concept)]
Simplifie la ABox des concepts dans ABoxCS selon la TBox
*/
aboxcs([],_,[]).
aboxcs([(I,C)|Q],TBox,[(I,C)|ABoxCS]) :-
    setof(X,cnamea(X),Lca), 
    member(C,Lca), % Pas de simplification requise
    aboxcs(Q,TBox,ABoxCS),
    !.
aboxcs([(I,C)|Q],TBox,[(I,EC)|ABoxCS]) :-
    member((C,EC),TBox), % Simplification
    aboxcs(Q,TBox,ABoxCS),
    !.
aboxcs([(I,not(C))|Q],TBox,[(I,not(EC))|ABoxCS]) :-
    member((C,EC),TBox), /* Récurrence sur les expressions 
                            correctes (not,and,or,some,all) */
    aboxcs(Q,TBox,ABoxCS),
    !.
aboxcs([(I,and(C1,C2))|Q],TBox,[(I,and(EC1,EC2))|ABoxCS]) :-
    member((C1,EC1),TBox),
    member((C2,EC2),TBox),
    aboxcs(Q,TBox,ABoxCS),
    !.
aboxcs([(I,or(C1,C2))|Q],TBox,[(I,or(EC1,EC2))|ABoxCS]) :-
    member((C1,EC1),TBox),
    member((C2,EC2),TBox),
    aboxcs(Q,TBox,ABoxCS),
    !.
aboxcs([(I,some(R,C))|Q],TBox,[(I,some(R,EC))|ABoxCS]) :-
    member((C,EC),TBox),
    aboxcs(Q,TBox,ABoxCS),
    !.
aboxcs([(I,all(R,C))|Q],TBox,[(I,all(R,EC))|ABoxCS]) :-
    member((C,EC),TBox),
    aboxcs(Q,TBox,ABoxCS),
    !.

/* 
aboxcnnf/2 : ABoxC=Liste[(Instance,Expression)], ABoxCNNF=Liste[(Instance,Expression)], 
Renvoie dans ABoxCNNF la ABox mise sous FNN
*/
aboxcnnf([],[]).
aboxcnnf([(I,EC)|Q],[(I,NNFEC)|ABOXCNNF]) :-
    nnf(EC,NNFEC),
    aboxcnnf(Q,ABOXCNNF),
    !.

/*
aboxs/3: ABox=[Liste[(Instance,Concept)], Liste[(Instance,,Instance,Role)]], 
         TBox=Liste[(Concept,Expression)], 
         ABoxS=[Liste[(Instance,Concept)], Liste[(Instance,,Instance,Role)]]
Simplifie la ABox dans ABoxS selon la TBox
*/
aboxs([ABoxC,ABoxR],TBox,[ABoxCS | [ABoxR]]) :-
    aboxcs(ABoxC,TBox,ABoxCS),
    !.

/*
traitement_ABox/3: ABox=[Liste[(Instance,Concept)], Liste[(Instance,Instance,Role)]], 
                   TBoxT=Liste[(Concept,Expression)], 
                   ABoxS=[Liste[(Instance,Concept)], Liste[(Instance,,Instance,Role)]
Vérifie la correction de la ABox et la simplifie selon la TBoxT puis la passe en FNN dans
ABoxT
*/
traitement_ABox(ABox, TBox, [ABoxCSNNF|[ABoxRS]]) :-
    aboxcor(ABox),
    traitement_TBox(TBox,TBoxT),
    aboxs(ABox,TBoxT,[ABoxCS,ABoxRS]),
    aboxcnnf(ABoxCS,ABoxCSNNF),
    !.

/*--- Synthèse de la partie 1 ---*/

/* 
premiere_etape/3: Tbox=Liste[(Concept,Expression)], Abi=Liste[(Instance,Concept)],
                  Abr=Liste[(Instance,,Instance,Role)]
Effectue les traitements sur la base de fait et rend la Tbox, la ABox des concepts dans Abi
et la ABox des roles dans Abr
*/
premiere_etape(Tbox,Abi,Abr) :-
    setof((C1,EC),equiv(C1,EC),TboxNT),
    traitement_TBox(TboxNT,Tbox),
    setof((I1,C2),inst(I1,C2),AbiNT),
    setof((I2,I3,R),instR(I2,I3,R),AbrNT),
    traitement_ABox([AbiNT|[AbrNT]],Tbox,[Abi,Abr]),
    !.