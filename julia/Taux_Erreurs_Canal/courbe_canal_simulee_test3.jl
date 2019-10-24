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
include("../Commun/erreur_canal.jl")
include("../Commun/canal.jl")
close("all")

EBN0 = 3
TAILLE_MESSAGE = 10000
TAILLE_CANAL = 5001
SURECHANTILLONNAGE = 10
FORMANT_EMISSION = formantcos(10000,SURECHANTILLONNAGE)
FILTRE_RECEPTION = formantcos(10000,SURECHANTILLONNAGE)
canal_entree = canal(TAILLE_CANAL, SURECHANTILLONNAGE)

erreur = erreur_canal(EBN0, TAILLE_MESSAGE, SURECHANTILLONNAGE, FORMANT_EMISSION, FILTRE_RECEPTION, canal_entree)

println(erreur)


