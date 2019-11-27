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


### Définition de la fonction erreur
function erreur_canal(EBN0, TAILLE_MESSAGE, SURECHANTILLONNAGE, FORMANT_EMISSION, FILTRE_RECEPTION, canal)

    message = 2 .* bitrand(TAILLE_MESSAGE).-1;
    TAILLE_FORMANT = length(FORMANT_EMISSION)
    TAILLE_CANAL = (length(canal) - 1) / SURECHANTILLONNAGE
    formant = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);
    signal = emission(message, formant, SURECHANTILLONNAGE);
    signal = conv(signal, canal)
    # return(signal)
    signal = signal + bruit(EBN0, (signal'*signal)[1]/TAILLE_MESSAGE, length(signal));
    filtre = FILTRE_RECEPTION[end:-1:1];
    filtre = filtre[1:end,1]

    # signal = signal ./ sqrt((canal'*canal)[1]) #ajustement lié au gain du canal
    
    recu = reception(signal, filtre, SURECHANTILLONNAGE, 1+TAILLE_FORMANT*SURECHANTILLONNAGE/2+SURECHANTILLONNAGE*TAILLE_CANAL/2);
    
    recu = decision.(recu)
    
    return(sum(abs.(recu-message)/2))/TAILLE_MESSAGE


    
end

function erreur_canal_adaptatif(EBN0, TAILLE_MESSAGE, SURECHANTILLONNAGE, FORMANT_EMISSION, FILTRE_RECEPTION, canal, interferences_inverse)

    message = 2 .* bitrand(TAILLE_MESSAGE).-1;
    TAILLE_FORMANT = length(FORMANT_EMISSION)
    TAILLE_CANAL = (length(canal) - 1) / SURECHANTILLONNAGE
    formant = formantcos(SURECHANTILLONNAGE*TAILLE_FORMANT+1, SURECHANTILLONNAGE);

    signal = emission(message, formant, SURECHANTILLONNAGE);
    energie_totale = (signal'*signal)
    signal = conv(signal, canal)
    # return(signal)
    
    EB = energie_totale/(TAILLE_MESSAGE);
    signal = signal + bruit(EBN0, EB, length(signal));

    # signal = signal ./ sqrt((canal'*canal)[1]) #ajustement lié au gain du canal
    
    recu = conv(signal, filtre)

    recu = synchronisation(recu, 1+TAILLE_FORMANT*SURECHANTILLONNAGE/2+TAILLE_CANAL*SURECHANTILLONNAGE/2, filtre, SURECHANTILLONNAGE);

    recu = conv(recu,interferences_inverse[end:-1:1])

    
    # plot(recu)

    temps_synchro = trunc(Int,(length(interferences_inverse)+1)/2)
    # temps_synchro=1

    recu = recu[temps_synchro:1:end-temps_synchro+1]


    recu = decision.(recu)

    # println(length(recu))
    # println(TAILLE_MESSAGE)
    
    
    return(sum(abs.(recu-message)/2))/TAILLE_MESSAGE


    
end