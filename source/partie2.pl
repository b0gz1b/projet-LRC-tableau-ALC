/************
 * Partie 2 *
 ************/
:-[partie1].
/*
 deuxieme_etape/3: Abi=Liste[(Instance,Concept)]
        ,Abi1=Liste[(Instance,Concept)],
        Tbox=Liste[(Concept,Expression)]
*/

deuxieme_etape(Abi,Abi1,Tbox) :-
    saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox).


/*
 saisie_et_traitement_prop_a_demontrer/3: Abi=Liste[(Instance,Concept)]
        ,Abi1=Liste[(Instance,Concept)],
        Tbox=Liste[(Concept,Expression)]
S'occupe de choisir le type de proposition à démontrer en fonction du
souhait de l'utilisateur.
*/

saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox) :-
    nl,
    write("Entrer le numero du type de proposition que l'on souhaite demontrer :"),
    nl,
    write("1 Une instance donnee appartient a un concept donne."),
    nl,
    write("2 Deux concepts n'ont pas d'elements en commun(ils ont une intersection vide)."),
    nl,
    read(R),
    suite(R,Abi,Abi1,Tbox).

/*
suite/4: s'occupe d'effectuer l'acquisition de la proposition de type 1
ou 2 en fonction de ce que l'utilisateur a pu indiquer. Toute autre
entrée que 1 ou 2 redemandera à l'utilisateur d'entrer le numero.
*/

suite(1,Abi,Abi1,Tbox) :-
 acquisition_prop_type1(Abi,Abi1,Tbox),!.

suite(2,Abi,Abi1,Tbox) :-
 acquisition_prop_type2(Abi,Abi1,Tbox),!.

suite(_,Abi,Abi1,Tbox) :-
    nl,
    write('Cette reponse est incorrecte.'),
    nl,
    saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox).


acquisition_prop_type1(Abi,Abi1,Tbox) :-
    nl,
    write("Quelle est l'instance ? :"),
    nl,
    read(I),
    instance(I),

    nl,
    write('Quel est le concept ? :'),
    nl,
    read(C),
    concept(C), % pas sûr que ce soit suffisant comme vérification


    setof(X,cnamena(X),Lcc),
    setof(Y,cnamea(Y),Lca),

/* à vérifier */
    remplacecomplexe(C,Tbox,Lcc,Lca,CT), % n'a pas l'air de renvoyer ce qu'on veut
    nnf(not(CT),NNCT), % passage en FNN
    concat([(I,NNCT)],Abi,Abi1).

acquisition_prop_type2(Abi,Abi1,Tbox) :-
    nl,
    write('Quelle est le premier concept ? :'),
    nl,
    read(C1),
    concept(C1), % pas sûr que ce soit suffisant comme vérification

    nl,
    write('Quel est le second concept ? :'),
    nl,
    read(C2),
    concept(C2), % pas sûr que ce soit suffisant comme vérification


    setof(X,cnamena(X),Lcc),
    setof(Y,cnamea(Y),Lca),

/* à vérifier */
    remplacecomplexe(and(C1,C2),Tbox,Lcc,Lca,CT),
    nnf(CT,NNCT), % passage en FNN


    genere(I),
    concat([(I,NNCT)],Abi,Abi1).
