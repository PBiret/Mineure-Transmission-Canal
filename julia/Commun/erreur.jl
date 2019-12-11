#author : Pierre Biret, Nicolas Georgin
#derniere modification : 310-oct-2019

using PyPlot
using Random #pacakge random pour la génération de message
using DSP
include("../Commun/emission.jl")
include("../Commun/reception.jl")
include("../Commun/formantcos.jl")
include("../Commun/formantrect.jl")
include("../Commun/bruit.jl")

### Définition de la fonction erreur
function erreur(EBN0, TAILLE_MESSAGE, SURECHANTILLONNAGE, FORMANT_EMISSION, FILTRE_RECEPTION)

    message = 2 .* bitrand(TAILLE_MESSAGE).-1;
    TAILLE_FORMANT = length(FORMANT_EMISSION)
    formant = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
    signal = emission(message, formant, SURECHANTILLONNAGE);
    signal = signal + bruit(EBN0, (formant'*formant)[1], size(signal,1));
    filtre = formant[end:-1:1] / (formant'*formant);
    filtre = filtre[1:end,1];
    recu = reception(signal, filtre, SURECHANTILLONNAGE, 1+TAILLE_FORMANT*SURECHANTILLONNAGE/2);
    recu = decision.(recu);
    
    return(sum(abs.(recu-message)/2))/TAILLE_MESSAGE


    
end

