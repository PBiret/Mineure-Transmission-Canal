#author : Pierre Biret, Nicolas Georgin
#derniere modification : 28-nov-2019

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


TAILLE_CANAL = 11xœ
SURECHANTILLONNAGE = 30
TAILLE_FORMANT = 30
FORMANT_EMISSION = formantcos(TAILLE_FORMANT*SURECHANTILLONNAGE+1,SURECHANTILLONNAGE)
canal_entree = canal(TAILLE_CANAL*SURECHANTILLONNAGE+1, SURECHANTILLONNAGE)

TAILLE = 20	; #nombre de points à tracer
RAPPORT_MIN = 0; #Eb/N0 minimal
RAPPORT_MAX = 8; #Eb/N0 maximal
TAILLE_MESSAGE = 10000
NB_SIMULATIONS = 10

## définition de la réponse impulsionnelle du filtre naif

Length_mess = 21;

message = zeros(Length_mess);
message[Int((Length_mess+1)/2)] = 1;


formant = FORMANT_EMISSION;

filtre = conv(formant, canal_entree)[end:-1:1];
TAILLE_FORMANT = length(FORMANT_EMISSION)


signal = emission(message, formant, SURECHANTILLONNAGE);
signal_recu = conv(signal, canal_entree)
signal_recu = conv(signal_recu, filtre)
signal_recu = synchronisation(signal_recu, 1+length(filtre)/2, filtre, SURECHANTILLONNAGE)

#plot(signal_recu)

interferences_frequences = fft(signal_recu);

#plot(interferences_frequences);

interferences_frequences_inverse = 1 ./ interferences_frequences

interferences_inverse = real.(ifft(interferences_frequences_inverse));

#plot(interferences_inverse);

interferences_inverse = [interferences_inverse[2:end];0] #Le décalage fait pas julia est inexpliqué

eb_n0 = collect(RAPPORT_MIN:(RAPPORT_MAX - RAPPORT_MIN)/TAILLE:RAPPORT_MAX);

Nbpt = length(eb_n0);

taux_binaire_min = zeros(Nbpt);
taux_binaire_max = zeros(Nbpt);

Threads.@threads for j = 1:length(eb_n0)

    erreur_min = 1;
    erreur_max = 0;

    print("Eb/N0 = ", eb_n0[j], " \n")
    for i = 1:NB_SIMULATIONS
        erreur = erreur_canal_adaptatif(eb_n0[j], TAILLE_MESSAGE, SURECHANTILLONNAGE, formant, filtre ,canal_entree,interferences_inverse); #récupération de la valeur de l'erreur
        erreur_min = min(erreur_min, erreur)
        erreur_max = max(erreur_max, erreur)
        
    end
    taux_binaire_min[j] = erreur_min;
    taux_binaire_max[j] = erreur_max;
    
end

#tracé de la figure
# figure()
plot(eb_n0, taux_binaire_min; color="black");
plot(eb_n0, taux_binaire_max; color="black");
