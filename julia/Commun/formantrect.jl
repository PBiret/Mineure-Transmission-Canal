#author : Pierre Biret
#derniere modification : 26-sept-2019

function formantrect(TAILLE, SURECHANTILLONNAGE)
    PI = 3.1415926535; #définition de pi 
    formant = zeros(TAILLE); #initiationsation du vecteur de sortie à 0
    t = (collect(1:1:TAILLE) .- Int(floor((TAILLE+1)/2))) / SURECHANTILLONNAGE; #création du vecteur d'abscisses 
    for i=1:TAILLE #définition des ordonnées
        if t[i] == 0 
            formant[i] = 1; #cas particulier t[i] = 0 pour éviter la division par 0
        else
            formant[i] = sin(PI*t[i]) ./ (PI*t[i]); #formule générale du formant pour t[i] != 0
        end
    end
    return formant;
end