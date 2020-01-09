#include <iostream>

#include "Document.h"
#include "Livre.h"
#include "Article.h"
#include "Biblio.h"


int main() {
    //Document
    auto *s =new  string("Since a portal ");
    string nom = "Solo Leveling";
    //Document document(nom, s, "Chu-Gong");

    //Livre
    Livre livre(nom,s,"Chu-Gong",2018,"Papyrus, KakaoPage");

    //article
    Article article(nom,s,"Chu-Gong","IEEE","Papyrus, KakaoPage",2018);

    list <Document*> test;
    //test.push_front(&document);
    Biblio b(test);

    b.ajouter(&livre);
    //b.ajouter(&document);
    b.ajouter(&article);
    b.afficher();


    return 0;
}