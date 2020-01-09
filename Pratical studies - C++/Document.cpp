//
// Created by James Le Poidevin on 19/11/2019.
//

#include "Document.h"

#include <utility>

Document::Document(string &titrefunc, string *resumefunc, string auteurfunc) : titre(titrefunc) ,resume(resumefunc),auteur(std::move(auteurfunc)){}

void Document::afficher() {
    cout << "Titre : " << titre << endl;
    cout << "Auteur : " << auteur << endl;
    cout << "Resumé : "  << *resume << endl ;
}

//Pour la partie 1 du TP 4
/*
Document Document::cloner() {
    return Document*(*this);
}

Document &Document::operator=(const Document documentfunc) {
    if (this != &documentfunc) {
        this->titre = documentfunc.titre;
        resume = new string();
        *resume = *documentfunc.resume;
        this->auteur = documentfunc.auteur;
    }
    return *this;
}*/
