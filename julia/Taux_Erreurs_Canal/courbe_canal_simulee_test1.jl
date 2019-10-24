#author : Pierre Biret
#derniere modification : 24-oct-2019

using PyPlot
using Random #pacakge random pour la génération de message
using DSP
include("../Commun/emission.jl")
include("../Commun/reception.jl")
include("../Commun/plot_apres_formant.jl")
include("../Commun/formantcos.jl")
include("../Commun/formantrect.jl")
include("../Commun/bruit.jl")
include("../Commun/erreur_canal.jl")
close("all")

EBN0 = 3
TAILLE_MESSAGE = 10000
SURECHANTILLONNAGE = 10
FORMANT_EMISSION = formantcos(10000,SURECHANTILLONNAGE)
FILTRE_RECEPTION = formantcos(10000,SURECHANTILLONNAGE)
canal_entree = [1]


TAILLE = 16; #nombre de points à tracer
RAPPORT_MIN = 0; #Eb/N0 minimal
RAPPORT_MAX = 8; #Eb/N0 maximal
SURECHANTILLONNAGE = 30
TAILLE_MESSAGE = 10000
NB_SIMULATIONS = 20

taux_binaire = []; #initialisation du vecteur d'erreur binaire min
eb_n0 = collect(RAPPORT_MIN:(RAPPORT_MAX - RAPPORT_MIN)/TAILLE:RAPPORT_MAX);
formant = formantcos(10000,10)
for j = 1:length(eb_n0)
    erreur = 0
    print("Eb/N0")
    print(" = ")
    print(eb_n0[j])
    print("\n")
    for i = 1:NB_SIMULATIONS
        erreur = erreur + erreur_canal(eb_n0[j], TAILLE_MESSAGE, SURECHANTILLONNAGE, formant, formant,canal_entree); #récupération de la valeur moyenne des erreurs
    end
    global taux_binaire = [taux_binaire;erreur/NB_SIMULATIONS];
    
end

#tracé de la figure
plot(eb_n0, taux_binaire; color="blue");
