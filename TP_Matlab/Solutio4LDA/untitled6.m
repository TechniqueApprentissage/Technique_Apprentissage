load fisheriris;

X = meas; % Features
Y = species; % Labels
untitled6(X, Y);

data_normalized = zscore(meas);
[coeff, score, latent, ~, explained] = pca(data_normalized);
% Tracer la variance expliquée
bar(explained);
xlabel('Composante Principale');
ylabel('Variance Expliquée (%)');
title('Variance Expliquée par les Composantes Principales');
