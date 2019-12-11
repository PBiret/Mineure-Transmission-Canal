#author : Pierre Biret, Nicolas Georgin
#derniere modification : 31-oct-2019

using PyPlot
using DSP
include("../Commun/decision.jl")
include("../Synchronisation/synchronisation.jl")

function reception(signal, FILTRE_RECEPTION, SURECHANTILLONNAGE, SYNCHRONISATION)

    signal_recu = conv(signal, FILTRE_RECEPTION) #passage dans le filtre de reception

    signal_recu_echantillone = synchronisation(signal_recu, SYNCHRONISATION, FILTRE_RECEPTION, SURECHANTILLONNAGE)
    
    
    # println(length(signal_recu_echantillone))

    # print(signal_recu_echantillone)

    return decision.(signal_recu_echantillone) #Passage par la fonction de décision


end
