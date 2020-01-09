//
// Created by James Le Poidevin on 19/11/2019.
//

#ifndef TP4_BIBLIO_H
#define TP4_BIBLIO_H

#include <list>
#include <iostream>
#include "Document.h"

using namespace std;

class Biblio {
    list <Document*> tab;

public:
    explicit Biblio(list <Document*> tabfunc);
    void ajouter (Document *D);
    Document* rechercher(string T);
    void afficher();
};


#endif //TP4_BIBLIO_H
