#author : Pierre Biret
#derniere modification : 3-oct-2019

using DSP

function emission(message, FORMANT_EMISSION, SURECHANTILLONNAGE)

    TAILLE_MESSAGE = length(message)

    signal_temporel = zeros((TAILLE_MESSAGE-1)*SURECHANTILLONNAGE + 1) #nombre de points après surechantillonage
    signal_temporel[1:SURECHANTILLONNAGE:TAILLE_MESSAGE*SURECHANTILLONNAGE] = message; #valeur du sous-echantillonnage = message

    signal_temporel = conv(signal_temporel, FORMANT_EMISSION) #passage dans le formant d'emission

    return(signal_temporel)

end