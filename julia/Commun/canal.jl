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

function canal(TAILLE_CANAL, SURECHANTILLONNAGE, TEMPS_CHARACTERISTIQUE=1)
    x = collect(0:1:TAILLE_CANAL÷2) # vecteur x
    reponse_impulsionnelle = zeros(TAILLE_CANAL) # Initialisation des Ordonnées
    reponse_impulsionnelle[TAILLE_CANAL÷2+1:end]= exp.(-1 * collect(0:1:TAILLE_CANAL÷2) ./ (SURECHANTILLONNAGE*TEMPS_CHARACTERISTIQUE)) # Ordonnées 
    return(reponse_impulsionnelle)
end
