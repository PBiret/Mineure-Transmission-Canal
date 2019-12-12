#author : Pierre Biret, Nicolas Georgin
#derniere modification : 26-sept-2019

function formantcos(TAILLE, SURECHANTILLONNAGE)
    PI = 3.1415926535; #définition de pi 
    formant = zeros(TAILLE); #initiationsation du vecteur de sortie à 0
    t = (collect(1:1:TAILLE).-floor((TAILLE+1)/2)) / SURECHANTILLONNAGE; #création du vecteur d'abscisses 
    for i=1:TAILLE #définition des ordonnées
        if (t[i]*t[i]) == (1/16)
            formant[i] = PI / 4; #cas particulier t[i] * t[i] = 1/16 pour éviter la division par 0
        else
            formant[i] = cos(2*PI*t[i]) ./ (1 - 16 * t[i] * t[i]); #formule générale du formant pour t[i] * t[i] != 1/16
        end;
    end
    return formant;
end
