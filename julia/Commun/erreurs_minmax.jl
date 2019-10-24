#author : Pierre Biret
#derniere modification : 310-oct-2019

using PyPlot
using Random #pacakge random pour la génération de message
using DSP

include("../Commun/erreur.jl")
close("all")

function simul_erreur(EBN0, TAILLE_MESSAGE, SURECHANTILLONNAGE, FORMANT_EMISSION, FILTRE_RECEPTION, NOMBRE_SIMULATIONS) #renvoie le min et le max pour un nombre de simulations donné
    simulations = zeros(NOMBRE_SIMULATIONS,1)
    for i = 1:NOMBRE_SIMULATIONS
        print("Simulation ")
        print(i)
        print(" sur ")
        print(NOMBRE_SIMULATIONS)
        print("\n")
        simulations[i] = erreur(EBN0, TAILLE_MESSAGE, SURECHANTILLONNAGE, FORMANT_EMISSION, FILTRE_RECEPTION)
    end
    # print(simulations)

    max_val = maximum(simulations)
    min_val = minimum(simulations)

    return([min_val,max_val])
end
