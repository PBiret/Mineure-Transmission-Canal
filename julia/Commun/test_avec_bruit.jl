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
include("../Commun/bruit.jl")

close("all")

TAILLE_MESSAGE = 1000;
SURECHANTILLONNAGE = 30;
TAILLE_FORMANT = 100;
message = 2 .* bitrand(TAILLE_MESSAGE).-1; 
formant = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
signal = emission(message, formant, SURECHANTILLONNAGE);
signal = signal + bruit(5, (formant'*formant)[1], size(signal,1));
filtre = formant[end:-1:1] / (formant'*formant);
filtre = filtre[1:end,1];
recu = reception(signal, filtre, SURECHANTILLONNAGE, 1+TAILLE_FORMANT*SURECHANTILLONNAGE/2);

sum(abs.(recu-message)/2)






