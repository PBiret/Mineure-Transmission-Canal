#author : Pierre Biret, Nicolas Georgin
#derniere modification : 3-oct-2019

using PyPlot
using SpecialFunctions #erfc fait partie du package SpecialFunctions

TAILLE = 1000; #nombre de points à tracer
RAPPORT_MIN = 0; #Eb/N0 minimal
RAPPORT_MAX = 8; #Eb/N0 maximal

taux_binaire = zeros(TAILLE); #initialisation du vecteur d'erreur binaire

### initialisation du vecteur en abscisse (Eb/N0)
eb_n0 = collect(RAPPORT_MIN:(RAPPORT_MAX - RAPPORT_MIN)/TAILLE:RAPPORT_MAX);

#passage en linéaire
eb_n0_lin = 10 .^ (eb_n0 ./ 10);

### Calcul de la fonction de taux d'erreur binaire
taux_binaire = 0.5 * erfc.(sqrt.(eb_n0_lin));

#tracé de la figure
plot(eb_n0, taux_binaire, color="red")
