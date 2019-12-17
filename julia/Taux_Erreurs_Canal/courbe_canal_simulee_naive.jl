#author : Pierre Biret, Nicolas Georgin
#derniere modification : 28-nov-2019

using PyPlot
using Random #package random pour la génération de message
using DSP
include("../Commun/emission.jl")
include("../Commun/reception.jl")
include("../Commun/plot_apres_formant.jl")
include("../Commun/formantcos.jl")
include("../Commun/formantrect.jl")
include("../Commun/bruit.jl")
include("../Commun/erreur_canal.jl")
include("../Commun/canal.jl")

println(Threads.nthreads());


TAILLE_CANAL = 11
SURECHANTILLONNAGE = 30
TAILLE_FORMANT = 30
FORMANT_EMISSION = formantcos(TAILLE_FORMANT*SURECHANTILLONNAGE+1,SURECHANTILLONNAGE)
canal_entree = canal(TAILLE_CANAL*SURECHANTILLONNAGE+1, SURECHANTILLONNAGE)

TAILLE = 20	; #nombre de points à tracer
RAPPORT_MIN = 0; #Eb/N0 minimal
RAPPORT_MAX = 8; #Eb/N0 maximal
TAILLE_MESSAGE = 10000
NB_SIMULATIONS = 10

eb_n0 = collect(RAPPORT_MIN:(RAPPORT_MAX - RAPPORT_MIN)/TAILLE:RAPPORT_MAX);


formant = FORMANT_EMISSION;
filtre = conv(formant, canal_entree);
filtre = filtre[end:-1:1]

Nbpt = length(eb_n0);

global taux_binaire_min = zeros(Nbpt);
global taux_binaire_max = zeros(Nbpt);


Threads.@threads for j = 1:Nbpt

    erreur_min = 1;
    erreur_max = 0;

    print("Eb/N0 = ", eb_n0[j], " \n")

    for i = 1:NB_SIMULATIONS
        erreur = erreur_canal(eb_n0[j], TAILLE_MESSAGE, SURECHANTILLONNAGE, formant, filtre,canal_entree); #récupération de la valeur de l'erreur
        erreur_min = min(erreur_min, erreur)
        erreur_max = max(erreur_max, erreur)
        
    end
    taux_binaire_min[j] = erreur_min;
    taux_binaire_max[j] = erreur_max;
    
end

#tracé de la figure
plot(eb_n0, taux_binaire_min; color="cyan");
plot(eb_n0, taux_binaire_max; color="cyan");


