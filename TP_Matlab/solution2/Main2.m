clc
clear ALL


% Load data from Text file
data = readtable("Iris.txt");
% Créer un masque logique pour chaque espèce
% Créer un masque logique en utilisant strcmp pour chaque espèce
% Créer un masque logique en tenant compte du préfixe 'Iris-'
is_setosa = strcmp(data.Species, 'Iris-setosa');
is_versicolor = strcmp(data.Species, 'Iris-versicolor');
is_virginica = strcmp(data.Species, 'Iris-virginica');

species = {'Iris-setosa', 'Iris-versicolor', 'Iris-virginica'};
fprintf('\nStatistiques descriptives pour %s:\n', species{sp});
 % Continuation du script précédent pour inclure la variance
for sp = 1:length(species)
    mask = strcmp(data.Species, species{sp});
    species_data = data(mask, {'SepalLengthCm', 'SepalWidthCm', 'PetalLengthCm', 'PetalWidthCm'});

    fprintf('\nStatistiques descriptives pour %s:\n', species{sp});
    for col = 1:width(species_data)
        colData = species_data{:, col}; % Extraction des données en tant que tableau numérique
        fprintf('Moyenne pour la colonne %d : %.2f\n', col, mean(colData, 'omitnan'));
        fprintf('Écart-type pour la colonne %d : %.2f\n', col, std(colData, 'omitnan'));
        fprintf('Variance pour la colonne %d : %.2f\n', col, var(colData, 'omitnan'));  % Ajout de la variance
        fprintf('Médiane pour la colonne %d : %.2f\n', col, median(colData, 'omitnan'));
        fprintf('Minimum pour la colonne %d : %.2f\n', col, min(colData, [], 'omitnan'));
        fprintf('Maximum pour la colonne %d : %.2f\n', col, max(colData, [], 'omitnan'));
    end
end

for sp = 1:length(species)
    mask = strcmp(data.Species, species{sp});
    species_data = data(mask, {'SepalLengthCm', 'SepalWidthCm', 'PetalLengthCm', 'PetalWidthCm'});

    fprintf('\nStatistiques descriptives pour %s (Critères de Dispersion):\n', species{sp});
    for col = 1:width(species_data)
        colData = species_data{:, col};
        rangeValue = range(colData, 'omitnan');
        iqrValue = iqr(colData);
        cvValue = std(colData, 'omitnan') / mean(colData, 'omitnan') * 100;  % Coefficient de Variation en pourcentage

        fprintf('Colonne %d (%s):\n', col, species_data.Properties.VariableNames{col});
        fprintf('  Intervalle : %.2f\n', rangeValue);
        fprintf('  Écart Interquartile : %.2f\n', iqrValue);
        fprintf('  Coefficient de Variation : %.2f%%\n', cvValue);
    end
end
% Générer des boîtes à moustaches pour la longueur du sépale pour chaque espèce
figure;
boxplot(data.SepalLengthCm, data.Species, 'Labels', {'Iris-setosa', 'Iris-versicolor', 'Iris-virginica'});
title('Box Plot de la Longueur du Sépale par Espèce');
ylabel('Longueur du Sépale (cm)');
xlabel('Espèce');

% Répétez pour les autres caractéristiques (largeur du sépale, longueur du pétale, largeur du pétale)
% Générer un diagramme de dispersion pour la longueur vs. la largeur du sépale
figure;
gscatter(data.SepalLengthCm, data.SepalWidthCm, data.Species, 'rgb', 'osd');
title('Diagramme de Dispersion: Longueur vs Largeur du Sépale');
xlabel('Longueur du Sépale (cm)');
ylabel('Largeur du Sépale (cm)');
legend('Iris-setosa', 'Iris-versicolor', 'Iris-virginica');

