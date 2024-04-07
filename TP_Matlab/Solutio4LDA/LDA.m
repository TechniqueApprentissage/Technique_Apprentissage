
load fisheriris
X = meas; % Features
Y = species; % Labels


% En supposant que X et Y sont déjà définis comme vos caractéristiques et étiquettes

% Adapter le modèle LDA
ldaModel = fitcdiscr(X, Y);

% Adapter le modèle LDA
ldaModel = fitcdiscr(X, Y);

% Obtenir les vecteurs propres et valeurs propres de la matrice de covariance entre les classes
[eigenVectors, eigenValues] = eig(ldaModel.BetweenSigma, ldaModel.Sigma);

% Trier les vecteurs propres en fonction des valeurs propres décroissantes
[~, order] = sort(diag(eigenValues), 'descend');
sortedEigenVectors = eigenVectors(:, order);

% Projections LDA sur les deux premiers axes principaux
X_LDA = X * sortedEigenVectors(:,1:2);

% Vous pouvez maintenant tracer les deux premières projections LDA
figure;
gscatter(X_LDA(:,1), X_LDA(:,2), Y);
title('Projection LDA 2D du jeu de données Iris');
xlabel('Premier axe LDA');
ylabel('Deuxième axe LDA');
legend(unique(Y), 'Location', 'Best');


