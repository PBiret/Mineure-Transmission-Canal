#author : Pierre Biret
#derniere modification : 28-nov-2019

close("all")

println("tracé de courbe idéale")
include("../Taux_Erreurs_Canal/courbe_ideale.jl")

println("tracé de courbe idéale simulée")
include("../Taux_Erreurs_Canal/courbe_ideale_simulee.jl")

println("tracé de courbe canal simulée")
include("../Taux_Erreurs_Canal/courbe_canal_simulee.jl")

println("tracé de courbe canal filtre naif simulée")
include("../Filtre_adaptatif/courbe_canal_simulee_naive.jl")

println("tracé de courbe canal filtre sans interference")
include("../Filtre_adaptatif/courbe_canal_simulee_sansinterference.jl")

println("tracé de courbe canal filtre avec interference")
include("../Filtre_adaptatif/courbe_canal_simulee_avecinterference.jl")


legend(["courbe ideale theorique","courbe ideale simulee","","erreur canal simulee","","filtre naif simule","","filtre sans interference","","filtre avec interference","" ])