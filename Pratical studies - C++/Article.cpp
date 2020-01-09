//
// Created by James Le Poidevin on 19/11/2019.
//

#include "Article.h"

#include <utility>

using namespace std;

Article::Article(string &titrefunc, string *resumefunc, string auteur, string titrerevuefunc, string editeurfunc,
                 int numeroediteurfunc) : Document(titrefunc, resumefunc, std::move(auteur)),editeur(std::move(editeurfunc)),numeroediteur(numeroediteurfunc),titrerevue(std::move(titrerevuefunc)) {}

void Article::afficher() {
    Document::afficher(); // NOLINT(cppcoreguidelines-slicing)
    cout << "Titre Revue : " << titrerevue << endl;
    cout << "Editeur : " << editeur << endl;
    cout << "Numero de l'editeur : " << numeroediteur << endl;

}

Article Article::cloner() {
    return Article(*this);
}

Article &Article::operator=(const Article &articlefunc) {
    if (this != &articlefunc) {
        *this = articlefunc;
        this->titrerevue =articlefunc.titrerevue;
        this->editeur = articlefunc.editeur;
        this->numeroediteur = articlefunc.numeroediteur;
    }
    return *this;
}
