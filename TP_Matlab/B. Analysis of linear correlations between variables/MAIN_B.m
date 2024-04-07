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

species = unique(data.Species); 
% Labels uniques des espèces
colors = 'rgb'; 
% Couleurs pour chaque espèce
variables = {'SepalLengthCm', 'SepalWidthCm', 'PetalLengthCm', 'PetalWidthCm'}; % Variables à analyser

for i = 1:length(variables)
    for j = i+1:length(variables)
        figure; % Crée une nouvelle figure pour chaque paire de variables
        hold on; % superposer plusieurs graphiques
        
        % Boucle sur les espèces pour afficher les nuages de points colorés
        for s = 1:length(species)
            idx = strcmp(data.Species, species{s}); % Indices des données pour l'espèce actuelle
            scatter(data{idx, variables{i}}, data{idx, variables{j}}, colors(s), 'DisplayName', species{s});
            
            % Calcul de la corrélation et de la régression linéaire pour l'espèce actuelle
            [r, p] = corr(data{idx, variables{i}}, data{idx, variables{j}}); % Corrélation
            if p < 0.05 % Test de significativité
                coeffs = polyfit(data{idx, variables{i}}, data{idx, variables{j}}, 1); % Coefficients de régression
                xFit = linspace(min(data{idx, variables{i}}), max(data{idx, variables{i}}), 100);
                yFit = polyval(coeffs, xFit);
                plot(xFit, yFit, ['--', colors(s)], 'DisplayName', sprintf('Fit %s (r^2=%.2f)', species{s}, r^2)); % Ligne de régression
            end
        end
        
        xlabel(variables{i});
        ylabel(variables{j});
        title(sprintf('Correlation between %s and %s', variables{i}, variables{j}));
        legend('show');
        hold off; % Ne plus superposer pour la prochaine figure
    end
end
