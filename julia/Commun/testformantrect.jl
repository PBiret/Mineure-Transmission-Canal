#author : Pierre Biret, Nicolas Georgin
#derniere modification : 26-sept-2019

using PyPlot #utilisation de PyPlot pour tracer la courbe
include("../Commun/formantrect.jl"); #chargement en mémoire de la fonction formantrect

#Définition des variables
SURECHANTILLONNAGE = 10;
TAILLE_FORMANT=10*SURECHANTILLONNAGE+1;

#calcul des ordonnées correspondant au formant rectangulaire
formant = formantrect(TAILLE_FORMANT,SURECHANTILLONNAGE); 

#création du vecteur d'abscisses
x = collect(1:1:length(formant)); 
x = (x .- (length(formant)+1)/2) ./ SURECHANTILLONNAGE;

plot(x,formant)
