#author : Pierre Biret
#derniere modification : 24-oct-2019

using PyPlot
using Random #package random pour la génération de message
using DSP
using FFTW

include("../Commun/emission.jl")
include("../Commun/reception.jl")
include("../Commun/plot_apres_formant.jl")
include("../Commun/formantcos.jl")
include("../Commun/formantrect.jl")
include("../Commun/bruit.jl")
include("../Commun/erreur_canal.jl")
include("../Commun/canal.jl")

EBN0 = 5
TAILLE_CANAL = 11
SURECHANTILLONNAGE = 30
TAILLE_FORMANT = 30
FORMANT_EMISSION = formantcos(TAILLE_FORMANT*SURECHANTILLONNAGE,SURECHANTILLONNAGE)
canal_entree = canal(TAILLE_CANAL*SURECHANTILLONNAGE+1, SURECHANTILLONNAGE)

TAILLE = 8; #nombre de points à tracer
RAPPORT_MIN = 0; #Eb/N0 minimal
RAPPORT_MAX = 8; #Eb/N0 maximal
SURECHANTILLONNAGE = 30
TAILLE_MESSAGE = 10000
NB_SIMULATIONS = 10

## définition de la réponse impulsionnelle en fréquence

message = zeros(101)
message[trunc(Int,(length(message)+1)/2)] = 1


formant = FORMANT_EMISSION;

filtre = formant[end:-1:1];
TAILLE_FORMANT = length(formant)

TAILLE_FORMANT = length(FORMANT_EMISSION)
signal = emission(message, formant, SURECHANTILLONNAGE);
signal_recu = conv(signal, canal_entree)
signal_recu = conv(signal_recu, filtre)


# println(length(signal_emis))

signal_recu = synchronisation(signal_recu, 1+TAILLE_CANAL*SURECHANTILLONNAGE/2+TAILLE_FORMANT/2, filtre, SURECHANTILLONNAGE)


# println(length(signal_recu))


interferences_frequences = fft(signal_recu)

interferences_frequences_inverse = 1 ./ interferences_frequences

interferences_inverse = real.(ifft(interferences_frequences_inverse))

# figure()
# plot(conv(interferences_inverse, signal_recu))



filtre = formant[end:-1:1];
# filtre = conv(filtre,interferences_inverse)[end:-1:1]


taux_binaire_min = []; #initialisation du vecteur d'erreur binaire min
taux_binaire_max = []
eb_n0 = collect(RAPPORT_MIN:(RAPPORT_MAX - RAPPORT_MIN)/TAILLE:RAPPORT_MAX);

for j = 1:length(eb_n0)
    erreur = 0
    global erreur_min = 1
    global erreur_max = 0
    print("Eb/N0")
    print(" = ")
    print(eb_n0[j])
    print("\n")
    for i = 1:NB_SIMULATIONS
        erreur = erreur_canal_adaptatif(eb_n0[j], TAILLE_MESSAGE, SURECHANTILLONNAGE, formant, filtre ,canal_entree,interferences_inverse); #récupération de la valeur de l'erreur
        erreur_min = min(erreur_min, erreur)
        erreur_max = max(erreur_max, erreur)
        
    end
    global taux_binaire_min = [taux_binaire_min;erreur_min];
    global taux_binaire_max= [taux_binaire_max;erreur_max];
    
end

#tracé de la figure
# figure()
plot(eb_n0, taux_binaire_min; color="green");
plot(eb_n0, taux_binaire_max; color="green");


