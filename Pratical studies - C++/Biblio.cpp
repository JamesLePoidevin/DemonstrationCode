//
// Created by James Le Poidevin on 19/11/2019.
//

#include "Biblio.h"

Biblio::Biblio(list <Document*> tabfunc){
    this->tab = tabfunc;
}

void Biblio::ajouter(Document* D) {
    tab.push_back(D);
}

Document *Biblio::rechercher(string T) {
    for (list<Document*>::iterator it = tab.begin(); it !=tab.end(); it++){
        if((*it)->titre ==T){
            return *it;
        }
    }
    return nullptr;
}

void Biblio::afficher() {
    cout << "\nAffichage de la biblio\n";
    for (list<Document*>::iterator it = tab.begin(); it !=tab.end(); it++){
        (*it)->afficher();
        cout << "Prix : " << (*it)->CalculerPrix();
        cout << "\n\n";
    }
}
