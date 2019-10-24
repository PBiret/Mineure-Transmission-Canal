#author : Pierre Biret
#derniere modification : 3-oct-2019

using PyPlot

function plot_apres_formant(signal_temporel, FORMANT_EMISSION, SURECHANTILLONNAGE)
    
    ### Alignement de l'abscisse temporelle sur les bits (le 0 se trouve après la moitié du formant)
    taille_signal_temporel = length(signal_temporel);
    abscisse_temporelle = collect(0:1:taille_signal_temporel-1);
    abscisse_temporelle = abscisse_temporelle .- (length(FORMANT_EMISSION)-1)/2; #Décalage temporel après passage dans la convolution
    abscisse_temporelle = abscisse_temporelle./SURECHANTILLONNAGE;

    plot(abscisse_temporelle, signal_temporel);

end

function plot_apres_formant_sortie(signal_recu, filtre, SURECHANTILLONNAGE)
    
    ### Alignement de l'abscisse temporelle sur les bits (le 0 se trouve après la moitié du formant)
    taille_signal_temporel = length(signal_recu);
    abscisse_temporelle = collect(0:1:taille_signal_temporel-1);
    abscisse_temporelle = abscisse_temporelle .- (length(filtre)-1); #Décalage temporel après passage dans la convolution
    abscisse_temporelle = abscisse_temporelle./SURECHANTILLONNAGE;

    figure()
    plot(abscisse_temporelle, signal_recu);

end