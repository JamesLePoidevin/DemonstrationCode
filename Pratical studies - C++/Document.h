//
// Created by James Le Poidevin on 19/11/2019.
//

#ifndef TP4_DOCUMENT_H
#define TP4_DOCUMENT_H

#include <iostream>
#include <string>

using namespace std;

class Document {
    friend class Biblio;

protected:
    string& titre;
    string* resume;
    string auteur;
public:

    Document(string &titrefunc,string* resumefunc,string auteurfunc);
    Document(const Document & documentfunc) = default;

    virtual void afficher();

    //ajouter =0 pour faire une methode abstraite
    virtual float CalculerPrix()=0;

    //Pas utile pour la partie 2
    //Document &operator=(Document documentfunc);
    //virtual Document cloner()=0;
};


#endif //TP4_DOCUMENT_H
