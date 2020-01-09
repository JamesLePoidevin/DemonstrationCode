# -*- coding: utf-8 -*-
"""
@author: Signol Clément et James Le Poidevin
"""

import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D


##############################################################################################################
# fonctionnement du programme :
# Séparé en 2 parties :
#    - Dans une première partie nous avons fait les fonctions
#    - La seconde est une partie d'exécution
# Pour tester nos fonction veillez à décommenter les parties qui vous intéresse
##############################################################################################################


################################################################################################
#################################### -- FONCTION -- ############################################
################################################################################################


#################################################
# Calcul du MGD du robot RRR
# qdegre = vecteur de configuration en degrée
# Xd = vecteur de situation = (x,y, theta)
#################################################
def mgd(qdegre):
    global longeurbras
    qrad = np.radians(qdegre)
    c1 = np.cos(qrad[0])
    s1 = np.sin(qrad[0])
    c12 = np.cos(qrad[0] + qrad[1])
    s12 = np.sin(qrad[0] + qrad[1])
    theta = qrad[0] + qrad[1] + qrad[2]
    c123 = np.cos(theta)
    s123 = np.sin(theta)
    thetadeg = np.degrees(theta)
    x = longeurbras[0] * c1 + longeurbras[1] * c12 + longeurbras[2] * c123
    y = longeurbras[0] * s1 + longeurbras[1] * s12 + longeurbras[2] * s123
    Xd = [x, y, thetadeg]
    return Xd


#################################################
# Calcul de la Jacobienne du robot pour une q
# qdegre = vecteur de configuration en degrée
# J: matrice Jacobienne 3x3
#################################################
def jacobienne(qdegre):
    global longeurbras
    qrad = np.radians(qdegre)
    c1 = np.cos(qrad[0])
    s1 = np.sin(qrad[0])
    c12 = np.cos(qrad[0] + qrad[1])
    s12 = np.sin(qrad[0] + qrad[1])
    theta = qrad[0] + qrad[1] + qrad[2]
    c123 = np.cos(theta)
    s123 = np.sin(theta)

    J = np.array([[-(longeurbras[0] * s1 + longeurbras[1] * s12 + longeurbras[2] * s123),
                   -(longeurbras[1] * s12 + longeurbras[2] * s123), -(longeurbras[2] * s123)],
                  [(longeurbras[0] * c1 + longeurbras[1] * c12 + longeurbras[2] * c123),
                   (longeurbras[1] * c12 + longeurbras[2] * c123), (longeurbras[2] * c123)],
                  [1, 1, 1]])
    return J


#################################################
# Newton
#################################################
def newton(qdegre, xd, nmax, epsilon, pasfunc):
    epsilonn = 1
    n = 0
    qk = qdegre
    direction = np.dot(np.linalg.inv(jacobienne(qdegre)), (xd - mgd(qdegre)))
    qk1 = qk + pasfunc * direction
    list_erreur = []
    while (n < nmax) and (epsilon < epsilonn):
        direction1 = np.dot(np.linalg.inv(jacobienne(qk1)), (xd - mgd(qk1)))
        qk1 = qk1 + pasfunc * direction1
        n += 1
        epsilonn = direction1[0] - direction[0] + direction1[1] - direction[1] + direction1[2] - direction[2]
        direction = direction1
        list_erreur.append(epsilonn)

    return direction, list_erreur


#################################################
# Gradient
#################################################
def gradient(qdegre, xd, nmax, epsilon, pasfunc):
    epsilonn = 1
    n = 0
    qk = qdegre
    J = jacobienne(qdegre)
    direction = np.dot(np.transpose(J), (xd - mgd(qdegre)))
    qk1 = qk + pasfunc * direction
    list_erreur = []
    while (n < nmax) and (epsilon < epsilonn):
        direction1 = np.dot(np.transpose(jacobienne(qk1)), (xd - mgd(qk1)))
        qk1 = qk1 + pasfunc * direction1
        n += 1
        epsilonn = np.abs(direction1[0] - direction[0] + direction1[1] - direction[1] + direction1[2] - direction[2])
        # print(epsilonn)
        direction = direction1
        list_erreur.append(epsilonn)

    return direction, list_erreur


#################################################
## Calcul de la direction de recherche
##################################################
def deplac(qdegre, qarriv, xd, nmax, epsilon, pasfunc, nbpas):
    xint = (qarriv[0] - qdegre[0]) / nbpas
    yint = (qarriv[1] - qdegre[1]) / nbpas
    thetaint = (qarriv[2] - qdegre[2]) / nbpas
    print(newton(qdegre, xd, nmax, epsilon, pasfunc))

    for i in range(nbpas + 1):
        x = qdegre[0] + i * xint
        y = qdegre[1] + i * yint
        theta = qdegre[2] + i * thetaint
        print(newton(np.asarray([x, y, theta]), xd, nmax, epsilon, pasfunc))
    return np.asarray([x, y, theta])


#################################################
## Calcul de la génération de trajectoire
##################################################
def genTrajectoire(A, B, q0, pas, nbIterations, eps, ech):
    v = np.asarray([B[0] - A[0], B[1] - A[1], B[2] - A[2]])

    q = []
    qt = q0

    for i in range(0, ech):
        X = np.asarray([A[0] + i * (v[0] / ech), A[1] + i * (v[1] / ech), A[2] + i * (v[2] / ech)])
        qt = newton(qt, X, nbIterations, eps, pas)
        q.append(qt)

    return q


################################################################################################
#################################### -- TEST -- ################################################
################################################################################################


# longueurs des corps du robot
longeurbras = [1, 1, 1]

#
# Exemple de configuration initiale (lecture des codeurs)
qinit = np.asarray([35., 50., 23.])
Xinit = np.asarray(mgd(qinit))

# Exemple de situation à atteindre
qbut = np.asarray([40., 40., 25.])
Xbut = np.asarray(mgd(qbut))
print("Xinit=", Xinit, " et Xbut=", Xbut)

# valeur à définir pour toutes les fonctions
nbIterations = 10
eps = 0.01
pas = 0.2

A = qinit
B = np.array([20, 20, 90])

print("nombre iteration=", nbIterations, ", epsilon=", eps, " et le pas=", pas)
print("A=", A, "  et B=", B)

#################################################
# Newton

q, list_erreur = newton(qinit,Xbut,nbIterations,eps,pas)
print("q = ",q)
plt.plot(list_erreur)

#################################################
# Gradian

# q, list_erreur = gradient(qinit,Xbut,nbIterations,eps,pas)
# print("q = ",q)
# plt.plot(list_erreur)


#################################################
# Generation de Trajectoire

# q = genTrajectoire(A, B, qinit, pas, nbIterations, eps, 25)
# print(q)
#
# fig = plt.figure()
# ax = plt.axes(projection="3d")
#
# ax.scatter(Xinit[0], Xinit[1], Xinit[2], c='tab:blue')
# ax.scatter(Xbut[0], Xbut[1], Xbut[2], c='tab:green')
# for qi in q:
#    X = mgd(qi)
#    print(X)
#    ax.scatter(X[0], X[1], X[2], c='tab:red')


plt.show()