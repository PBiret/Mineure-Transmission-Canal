#author : Pierre Biret, Nicolas Georgin
#derniere modification : 12-dec-2019


using DSP
using PyPlot

include("../Filtre_adaptatif/adaptatif_gradient.jl")

function test_gradient(TAILLE_FILTRE, TAILLE_SIGNAL, mu, filtre)

	#Generation d'un signal aléatoire

	signal = randn(TAILLE_SIGNAL);
	
	signal_filtre = conv(signal ,filtre);

	signal_filtre = signal_filtre[Int32(floor(length(filtre)/2)+1):end]
	filtre_gradient = adaptatif_gradient_init(TAILLE_FILTRE,mu);
	convergence = zeros(TAILLE_SIGNAL);
	
	for i = 1:TAILLE_SIGNAL
		err = adaptatif_gradient(signal[i], signal_filtre[i], filtre_gradient);
		convergence[i] = err;
	end
	print("Filtre : ", filtre_gradient.H, "\n");

	return convergence;

end

plot(test_gradient(11,250,0.1,[1, 2, 1]./4));
