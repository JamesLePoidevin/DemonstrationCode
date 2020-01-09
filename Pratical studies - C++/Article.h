//
// Created by James Le Poidevin on 19/11/2019.
//

#ifndef TP4_ARTICLE_H
#define TP4_ARTICLE_H

#include <iostream>
#include <string>

#include "Document.h"



class Article : public Document{
private:
    string titrerevue;
    string editeur;
    int numeroediteur =0;

public:
    Article(string &titrefunc, string *resumefunc, string auteur, string titrerevuefunc, string editeurfunc,
            int numeroediteurfunc = 0);
    Article(const Article &articlefunc) = default;
    virtual void afficher() override;
    Article cloner();

    float CalculerPrix(){return 15.99;}


    Article &operator=(const Article &articlefunc);
};


#endif //TP4_ARTICLE_H
