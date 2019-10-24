#author : Pierre Biret
#derniere modification : 10-oct-2019

using PyPlot # Une seule fois au lancement de Julia
using DSP
using Random
include("../Commun/reception.jl")
include("../Commun/emission.jl")
include("../Commun/formantrect.jl")
include("../Commun/formantcos.jl")
include("../Commun/decision.jl")

close("all")

TAILLE_MESSAGE = 1000;
SURECHANTILLONNAGE = 30;
TAILLE_FORMANT = 100;
message = 2 .* bitrand(TAILLE_MESSAGE).-1; #bitrand renvoie un tableau de 0 ou de 1 uniformément distribués
formant = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
signal = emission(message, formant, SURECHANTILLONNAGE);
filtre = formant[end:-1:1] / (formant'*formant); #On se met dans l'hypothèse d'une chaîne de transmission idéale de puissance 1 en mettant le pruit à 0
filtre = filtre[1:end,1];
recu = reception(signal, filtre, SURECHANTILLONNAGE, 1+TAILLE_FORMANT*SURECHANTILLONNAGE/2);

plot(recu)


sum(abs.(recu-message)/2)

