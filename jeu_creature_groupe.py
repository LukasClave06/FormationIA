#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 25 11:16:23 2021

@author: simplon
"""

import random 

# Classe Case
class Case:
    def __init__(self,x,y):
        self.x=x
        self.y=y
    def adjacentes(self,jeu):
        #(i.x-1 <= self.x <= i.x+1) and (i.y-1 <= self.y <= i.y+1) and not(self.x==i.x and self.y==i.x)
        l=[]
        for i in jeu.listeDesCases:
            if i.x == self.x and i.y == self.y:
                None
            else :
                if ( i.x == self.x or i.x==(self.x+1) or i.x==(self.x-1)) and ( i.y == self.y or i.y==(self.y+1) or i.y==(self.y-1)):
                    l.append(i)
        return l
    def __repr__(self):
        return repr((self.x,self.y))
   
    
# Classe jeu 
class Jeu:
    def __init__(self,listeDesCases,listeDesCreatures,tour,actif):
        self.listeDesCases=listeDesCases
        self.listeDesCreatures=listeDesCreatures
        self.tour=tour
        self.actif=actif
    def estOccuper(self,case):
        for i in self.listeDesCreatures:
            print(i.position)
            if i.position == case:
                return True
        return False
    def deplacer(self,creature,case):
        if self.estOccuper(case):
            self.tour=0
            creature.position=case
            print("Vainqueur : ",creature)
            return None
        else :
            creature.position=case
            self.tour+=1
            if self.actif == self.listeDesCreatures[0]:
                self.actif = self.listeDesCreatures[1]
            else :
                self.actif= self.listeDesCreatures[0]
            return case
    def __repr__(self):
        return repr((self.listeDesCases,self.listeDesCreatures,self.tour,self.actif))


# Classe créature
class Creature:
    def __init__(self,nom,position):
        self.nom=nom
        self.position=position
    def choisirCible(self,jeu):
        for i in self.position.adjacentes(jeu):
            if jeu.estOccuper(i):
                return i
        return random.choice(self.position.adjacentes(jeu))
    def __repr__(self):
        return repr((self.nom,self.position))
    
listeCase=[]
for i in range(1,5):
    for j in range(1,5):
        l=Case(i,j)
        listeCase.append(l)
print(listeCase)

listeCreature=[Creature('Chien à 3 têtes',Case(1,1)),Creature('Tirex à 3 têtes',Case(4,4))]

listeCreature

jeu1=Jeu(listeCase,listeCreature,1,listeCreature[0])

while jeu1.tour>0:
    print("actif :",jeu1.actif)
    jeu1.deplacer(jeu1.actif,jeu1.actif.choisirCible(jeu1))
    print(jeu1.listeDesCreatures)
    
    
    
##### Correction :
    


