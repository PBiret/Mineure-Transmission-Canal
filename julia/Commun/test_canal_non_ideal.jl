#author : Pierre Biret
#derniere modification : 24-oct-2019

using PyPlot
include("../Commun/canal.jl");
TAILLE_CANAL=10;
SURECHANTILLONNAGE=10;
lecanal = canal(TAILLE_CANAL*SURECHANTILLONNAGE+1, SURECHANTILLONNAGE);
x=collect(0:TAILLE_CANAL*SURECHANTILLONNAGE);
x=(x.-TAILLE_CANAL*SURECHANTILLONNAGE/2)/SURECHANTILLONNAGE;
plot(x, lecanal)