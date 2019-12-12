#author : Pierre Biret, Nicolas Georgin
#derniere modification : 10-oct-2019

function bruit(EBN0, EB, TAILLE)
    n0 = EB/(10^(EBN0/10))
    bruit = sqrt(n0/2) .* randn(TAILLE)
    return bruit
end
