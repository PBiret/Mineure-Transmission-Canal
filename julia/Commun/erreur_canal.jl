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
    formant = FORMANT_EMISSION;
    signal = emission(message, formant, SURECHANTILLONNAGE);
    signal = conv(signal, canal)
    # return(signal)
    signal = signal + bruit(EBN0, (signal'*signal)[1]/TAILLE_MESSAGE, length(signal));
    filtre = FILTRE_RECEPTION;
    signal = conv(signal, filtre)

    # signal = signal ./ sqrt((canal'*canal)[1]) #ajustement lié au gain du canal
    
    recu = synchronisation(signal, 1+TAILLE_CANAL*SURECHANTILLONNAGE/2+TAILLE_FORMANT/2, filtre, SURECHANTILLONNAGE);

    recu = decision.(recu)
    
    return(sum(abs.(recu-message)/2))/TAILLE_MESSAGE


    
end

function erreur_canal_adaptatif(EBN0, TAILLE_MESSAGE, SURECHANTILLONNAGE, FORMANT_EMISSION, FILTRE_RECEPTION, canal_entree, interferences_inverse)

    message = 2 .* bitrand(TAILLE_MESSAGE).-1;
    TAILLE_FORMANT = length(FORMANT_EMISSION)
    TAILLE_CANAL = (length(canal_entree) - 1) / SURECHANTILLONNAGE
    formant = FORMANT_EMISSION;
    filtre = FILTRE_RECEPTION

    signal = emission(message, formant, SURECHANTILLONNAGE);
    signal = conv(signal, canal_entree)

    energie_totale = (signal'*signal)
    # return(signal)
    
    EB = energie_totale/(TAILLE_MESSAGE)
    signal = signal + bruit(EBN0, EB, length(signal));

    # signal = signal ./ sqrt((canal'*canal)[1]) #ajustement lié au gain du canal
    
    recu = conv(signal, filtre)

    recu = synchronisation(recu, 1+length(filtre)/2, filtre, SURECHANTILLONNAGE);
    
    recu = conv(recu,interferences_inverse)

    
    # plot(recu)

    temps_synchro = trunc(Int,(length(interferences_inverse)+1)/2)
    # temps_synchro=1

    recu = recu[temps_synchro:1:end-temps_synchro+1]


    recu = decision.(recu)

    # println(length(recu))
    # println(TAILLE_MESSAGE)
    
    
    return(sum(abs.(recu-message)/2))/TAILLE_MESSAGE


    
end