//
// Created by James Le Poidevin on 19/11/2019.
//

#include "Livre.h"

#include <utility>

Livre::Livre(string &titrefunc, string *resumefunc, string auteurfunc, int anneefunc, string editeurfunc) : Document(titrefunc, resumefunc, auteurfunc),annee(anneefunc),editeur(std::move(editeurfunc)) {}

void Livre::afficher() {
    Document::afficher(); // NOLINT(cppcoreguidelines-slicing)
    cout << "Annee : " << annee << endl;
    cout << "Editeur : " << editeur << endl;
}

Livre Livre::cloner() {
    return Livre(*this);
}

Livre & Livre::operator=(const Livre &livrefunc){
    if (this != &livrefunc) {
        *this = livrefunc;
        this->annee =livrefunc.annee;
        this->editeur = livrefunc.editeur;
    }
    return *this;
}
