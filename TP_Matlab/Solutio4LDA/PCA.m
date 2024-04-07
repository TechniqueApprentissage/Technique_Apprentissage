% Charger le jeu de données Iris (supposons que les données sont dans une matrice "iris_data")
load fisheriris; % Ceci charge le jeu de données Iris dans MATLAB

% Normalisation des données
data_normalized = zscore(meas);

% Appliquer le PCA
[coeff, score, latent, ~, explained] = pca(data_normalized);

% Visualiser les résultats avec gscatter
gscatter(score(:,1), score(:,2), species, 'rgb', 'osd');
xlabel('1ère Composante Principale');
ylabel('2ème Composante Principale');
title('PCA du jeu de données Iris');
legend(unique(species), 'Location', 'Best');

% Afficher les valeurs propres et la variance expliquée
disp('Valeurs Propres :');
disp(latent);
disp('Variance Expliquée :');
disp(explained);
