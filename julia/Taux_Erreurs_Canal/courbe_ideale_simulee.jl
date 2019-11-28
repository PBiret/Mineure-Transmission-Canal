#author : Pierre Biret
#derniere modification : 10-oct-2019

using PyPlot


include("../Taux_Erreurs_Canal/erreurs_minmax.jl")
include("../Commun/formantcos.jl")

TAILLE = 8; #nombre de points à tracer
RAPPORT_MIN = 0; #Eb/N0 minimal
RAPPORT_MAX = 8; #Eb/N0 maximal
SURECHANTILLONNAGE = 30
TAILLE_MESSAGE = 10000
NB_SIMULATIONS = 5

taux_binaire_min = []; #initialisation du vecteur d'erreur binaire min
taux_binaire_max = []; #initialisation du vecteur d'erreur binaire max

### initialisation du vecteur en abscisse (Eb/N0)
eb_n0 = collect(RAPPORT_MIN:(RAPPORT_MAX - RAPPORT_MIN)/TAILLE:RAPPORT_MAX);
formant = formantcos(10000,10)

for j = 1:length(eb_n0)
    print("Eb/N0")
    print(" = ")
    print(eb_n0[j])
    print("\n")
    simul_resultats = simul_erreur(eb_n0[j], TAILLE_MESSAGE, SURECHANTILLONNAGE, formant, formant,NB_SIMULATIONS); #récupération des valeurs min et max du taux d'erreur simulé
    global taux_binaire_min = [taux_binaire_min;simul_resultats[1]];
    global taux_binaire_max = [taux_binaire_max;simul_resultats[2]];
    
end

#tracé de la figure
plot(eb_n0, taux_binaire_min, color="blue");
plot(eb_n0, taux_binaire_max, color="blue");