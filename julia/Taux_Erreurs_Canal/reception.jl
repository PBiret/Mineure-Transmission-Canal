#author : Pierre Biret
#derniere modification : 3-oct-2019

function reception(signal, FORMANT_RECEPTION, SURECHANTILLONNAGE)

    signal_recu = conv(signal, FORMANT_RECEPTION) #passage dans le formant de reception


    return(signal_recu)

end