clc
clear vars
close all

% Traitement 
%******************************************************************
% Load data from Text file
data = readtable("Iris.txt");
% Extract numeric data and Label
donnees = data{:, 2:5};  % Assuming the first 4 columns contain numeric data
etiquettes = data{:, "Species"}; % Assuming the 5th column contains class labels
unique_labels = unique(etiquettes);
num_classes = length(unique_labels);

% Question 1
%/*****************************************************************/
% A. Individual Analysis of Variables
num_variables = size(donnees, 2);
fprintf('Total number of variables: %d\n', num_variables);
fprintf('Total number classes: %d\n', num_classes);
fprintf('----------------------------------\n');
% Calculate statistics for each variable
%calculateStatistics(donnees);
%plotVariableHistograms(donnees, etiquettes, 20); % 20 bins pour les histogrammes
for i = 1:num_variables
    variable = donnees(:, i); % Extrait la i-ème colonne de données
    fprintf('Variable %d:\n', i);
    fprintf('Total data points: %d\n', length(variable));
    fprintf('Sum: %f\n', sum(variable));
    fprintf('Minimum: %f\n', min(variable));
    fprintf('Maximum: %f\n', max(variable));
    fprintf('Moyenne: %f\n', mean(variable));
    fprintf('Médiane: %f\n', median(variable));
    fprintf('Variance: %f\n', var(variable));
    fprintf('coef_variation: %f\n', std(variable)/ mean(variable));
    fprintf('Quartiles: %f\n', quantile(variable, [0.25, 0.75]));
    fprintf('Ecart-type: %f\n', std(variable));
    
    
     fprintf('----------------------------------\n');
end
for i = 1:num_variables
    variable = donnees(:, i); % Extrait la i-ème colonne de données
    figure; % Crée une nouvelle figure pour chaque histogramme
    histogram(variable, 5); % Crée un histogramme avec bacs
    title(['Histogramme de la Variable ' num2str(i)]);
    xlabel('Valeurs');
    ylabel('Fréquence');
end
boxplot(donnees, 'Labels', {'Variable 1', 'Variable 2', 'Variable 3', 'Variable 4'});
title('Diagrammes de boîte des Variables');
ylabel('Valeurs');

fprintf('----------------------------------\n');
fprintf('ANALYSE PAR CLASSES\n');

% Comptez le nombre d'exemples par classe
classe_counts = countcats(categorical(etiquettes));
% Créez un diagramme à barres pour visualiser la répartition des classes
bar(classe_counts);
title('Répartition des Classes dans l''Ensemble de Données Iris');
xlabel('Classes');
ylabel('Nombre d''Exemples');
xticklabels(unique(etiquettes));

%Calcul des statistiques descriptives par classe

unique_classes = unique(etiquettes); % Obtenez les classes uniques

% Variables pour stocker les statistiques par classe et par variable
means = zeros(length(unique_classes), 4);
stds = zeros(length(unique_classes), 4);

for i = 1:length(unique_classes)
    current_class = unique_classes{i}; % Sélectionnez la classe actuelle (utilisation des accolades {})
    indices = strcmp(etiquettes, current_class); % Indices des échantillons de la classe actuelle
    
    class_data = donnees(indices, :); % Données de la classe actuelle
    
    % Calcul des moyennes et écart-types pour chaque variable
    class_means = mean(class_data);
    class_stds = std(class_data);
    
    % Stockez les résultats dans les matrices
    means(i, :) = class_means;
    stds(i, :) = class_stds;
    
    fprintf('Statistiques pour la classe %s :\n', current_class);
    fprintf('Moyennes des Variables : %s\n', mat2str(class_means));
    fprintf('Ecart-types des Variables : %s\n', mat2str(class_stds));
end

fprintf('----------------------------------\n');
fprintf('----------------CORELATION------------------\n');unique_classes = unique(etiquettes); 


unique_classes = unique(etiquettes); % Obtenez les classes uniques

% Parcourez chaque classe
for i = 1:length(unique_classes)
    current_class = unique_classes{i};
         % Sélectionnez la classe actuelle (utilisation des accolades {})
    indices = strcmp(etiquettes, current_class); 
         % Indices des échantillons de la classe actuelle
    class_data = donnees(indices, :); 
         % Données de la classe actuelle
         % Calcul des coefficients de corrélation pour chaque paire de variables
    correlations = corr(class_data);
    
    % Affichage des coefficients de corrélation pour la classe actuelle
    fprintf('Matrice de Corrélation pour la classe %s :\n', current_class);
    disp(correlations);
    
    % visualiser les coefficients de corrélation sous forme de heatmap
    figure;
    heatmap({'Variable 1', 'Variable 2', 'Variable 3', 'Variable 4'}, ...
        {'Variable 1', 'Variable 2', 'Variable 3', 'Variable 4'}, ...
        correlations, 'Title', ['Heatmap de Corrélation pour la classe ' current_class]);
    colorbar;
end

% Supposons que vous ayez déjà chargé vos données et défini vos variables etiquettes et donnees
unique_classes = unique(etiquettes); % Obtenez les classes uniques

% Parcourez chaque classe
for i = 1:length(unique_classes)
    current_class = unique_classes{i}; % Sélectionnez la classe actuelle (utilisation des accolades {})
    indices = strcmp(etiquettes, current_class); % Indices des échantillons de la classe actuelle
    
    class_data = donnees(indices, :); % Données de la classe actuelle
    
    % Créez des scatter plots pour différentes paires de variables
    figure;
    scatter(class_data(:, 1), class_data(:, 2), 'Marker', 'o', 'DisplayName', 'Variable 1 vs. Variable 2');
    hold on;
    scatter(class_data(:, 1), class_data(:, 3), 'Marker', 'x', 'DisplayName', 'Variable 1 vs. Variable 3');
    scatter(class_data(:, 1), class_data(:, 4), 'Marker', '+', 'DisplayName', 'Variable 1 vs. Variable 4');
    
    xlabel('Variable 1');
    ylabel('Variables');
    title(['Scatter Plots for Class ' current_class]);
    
    legend;
    hold off;
end

