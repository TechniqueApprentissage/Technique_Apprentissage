clc
clear vars
close all

% Traitement 
%******************************************************************
% Load data 
% Extract des donnees ( numeric data and Label)
data = readtable("Iris.txt");
% Assuming the first 4 columns contain numeric data
donnees = data{:, 2:5};
 % la  5 colonne qui contient class labels
etiquettes = data{:, "Species"};
unique_labels = unique(etiquettes);
num_classes = length(unique_labels);

% Question 1
%/*****************************************************************/
% A. Individual Analysis 
num_variables = size(donnees, 2);
fprintf('Total number of variables: %d\n', num_variables);
fprintf('Total number classes: %d\n', num_classes);
fprintf('----------------------------------\n');
% Calcul statistique ôur chaque variable 
%calculateStatistics(donnees);
%plotVariableHistograms(donnees, etiquettes, 20); 
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
     % Extrait la i-ème colonne de données
    variable = donnees(:, i);
     % Crée une nouvelle figure pour chaque histogramme
    figure;
     % Crée un histogramme avec bacs
    histogram(variable, 5);
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
     % Sélectionnez la classe actuelle (utilisation des accolades {})
    current_class = unique_classes{i};
     % Indices des échantillons de la classe actuelle
    indices = strcmp(etiquettes, current_class);
    % Données de la classe actuelle
    class_data = donnees(indices, :); 
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
