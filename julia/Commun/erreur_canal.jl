#author : Pierre Biret, Nicolas Georgin
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

function erreur_canal_inter(EBN0, TAILLE_MESSAGE, SURECHANTILLONNAGE, FORMANT_EMISSION, FILTRE_RECEPTION, canal_entree, interferences_inverse)

    message = 2 .* bitrand(TAILLE_MESSAGE).-1;
    TAILLE_FORMANT = length(FORMANT_EMISSION);
    TAILLE_CANAL = Int((length(canal_entree) - 1) / SURECHANTILLONNAGE);
    formant = FORMANT_EMISSION;
    filtre = FILTRE_RECEPTION;

    signal = emission(message, formant, SURECHANTILLONNAGE);
    signal = conv(signal, canal_entree);

    EB = (signal'*signal)/(TAILLE_MESSAGE);

    # return(signal)
    signal = signal .+ bruit(EBN0, EB, length(signal));

    # signal = signal ./ sqrt((canal'*canal)[1]) #ajustement lié au gain du canal
    
    recu = conv(signal, filtre)
    recu = synchronisation(recu, 1+length(filtre)/2, filtre, SURECHANTILLONNAGE);
    recu = conv(recu,interferences_inverse);

    temp_synchro = (length(interferences_inverse)+1)/2;

    if (temp_synchro%1) == 0.5
	temp_synchro = (SYNCHRONISATION + (length(FILTRE_RECEPTION)-1)/2) + 0.5;
    end
    temp_synchro = Int(temp_synchro);

    recu = recu[temp_synchro:1:end-temp_synchro+1]  
    recu = decision.(recu)
    return(sum(abs.(recu-message)/2))/TAILLE_MESSAGE  
end
