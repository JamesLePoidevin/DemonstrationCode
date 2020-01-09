//
// Created by James Le Poidevin on 19/11/2019.
//
#ifndef TP4_LIVRE_H
#define TP4_LIVRE_H

#include <iostream>
#include <string>

#include "Document.h"

class Livre : public Document{
private:
    int annee;
    string editeur;

public:
    Livre(string &titrefunc, string *resumefunc, string auteur, int anneefunc, string editeurfunc);
    Livre(const Livre &livrefunc) = default;
    virtual void afficher() override;
    Livre cloner();
    float CalculerPrix(){return 9.0;}


    Livre &operator=(const Livre &livrefunc);
};


#endif //TP4_LIVRE_H
