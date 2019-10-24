#author : Pierre Biret
#derniere modification : 10-oct-2019

using PyPlot
using DSP
include("../Commun/decision.jl")

function reception(signal, FILTRE_RECEPTION, SURECHANTILLONNAGE, SYNCHRONISATION)

    signal_recu = conv(signal, FILTRE_RECEPTION) #passage dans le filtre de reception

    temp_synchro = trunc(Int,SYNCHRONISATION + (length(FILTRE_RECEPTION)-1)/2) #Calcul du temps de synchronisation après passage dans le filtre en sortie
    
    signal_recu_echantillone = signal_recu[temp_synchro:SURECHANTILLONNAGE:end-temp_synchro+SURECHANTILLONNAGE]
    
    return decision.(signal_recu_echantillone) #Passage par la fonction de décision


end
