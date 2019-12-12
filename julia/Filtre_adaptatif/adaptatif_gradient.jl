#author : Pierre Biret, Nicolas Georgin
#derniere modification : 12-dec-2019

mutable struct Filtre_gradient
	X::Array{Float64,1}
	Y::Array{Float64,1}
	H::Array{Float64,1}
	mu::Float64
end

#Initialisation de la variable se fait en utilisant son constructeur

function adaptatif_gradient_init(taille, mu)::Filtre_gradient
	filtre = Filtre_gradient(zeros(taille), zeros(Int32(floor(taille/2 + 1))), zeros(taille), mu);
	return filtre;
end


function adaptatif_gradient(x, y, filtre)::Float64
	filtre.X = [filtre.X[2:end]; x];
	filtre.Y = [filtre.X[2:end]; y];
	err = filtre.H' * filtre.X - filtre.Y[1];
	filtre.H = filtre.H - filtre.mu * filtre.X * err;
	return err;
end



