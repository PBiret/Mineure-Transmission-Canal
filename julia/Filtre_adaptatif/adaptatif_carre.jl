#author : Pierre Biret, Nicolas Georgin
#derniere modification : 12-dec-2019

mutable struct Filtre_carre
	X::Array{Float64,1}
	Y::Array{Float64,1}
	H::Array{Float64,1}
	mu::Float64
	#TODO
end

#Initialisation de la variable se fait en utilisant son constructeur

function adaptatif_carre_init(taille, mu)::Filtre_carre
	#TODO
	filtre = Filtre_gradient(zeros(taille), zeros(Int32(floor(taille/2 + 1))), zeros(taille), mu);

	return filtre;
end


function adaptatif_carre(x, y, filtre)::Float64
	#TODO
	filtre.X = [filtre.X[2:end]; x];
	filtre.y = [filtre.X[2:end]; y];
	err = filtre.H' * filtre.X - filtre.Y[1];
	filtre.H = filtre.H - filtre.mu * filtre.X * err;
	return err;
end



