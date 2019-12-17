#author : Pierre Biret, Nicolas Georgin
#derniere modification : 31-oct-2019

using DSP

function synchronisation(signal_recu, SYNCHRONISATION, FILTRE_RECEPTION, SURECHANTILLONNAGE)

    temp_synchro = (SYNCHRONISATION + (length(FILTRE_RECEPTION)-1)/2); #Calcul du temps de synchronisation après passage dans le filtre en sortie
    
    if (temp_synchro%1) == 0.5
	temp_synchro = (SYNCHRONISATION + (length(FILTRE_RECEPTION)-1)/2) + 0.5;
    end

    temp_synchro = Int(temp_synchro);
    signal_recu_echantillone = signal_recu[temp_synchro:SURECHANTILLONNAGE:end-temp_synchro+SURECHANTILLONNAGE-1]

    return signal_recu_echantillone

end
