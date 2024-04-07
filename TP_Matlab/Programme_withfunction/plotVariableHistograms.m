function plotVariableHistograms(data, labels, num_bins)
    % data: Matrice de données 
    % labels: Vecteur d'étiquettes de classe
    % num_bins: Nombre de bins pour les histogrammes

    num_variables = size(data, 2); % Nombre de variables
    unique_labels = unique(labels); % Différentes espèces

    % Parcours de chaque variable
    for i = 1:num_variables
        variable = data(:, i); % Sélectionnez la variable actuelle

        % Créez un nouveau graphique pour chaque variable
        figure;
        
        % Parcours de chaque espèce
        for j = 1:length(unique_labels)
            species_label = unique_labels{j}; % Espèce actuelle
            species_data = variable(strcmp(labels, species_label)); % Données pour l'espèce actuelle
            
            % Créez un histogramme pour l'espèce actuelle
            histogram(species_data, 'BinEdges', linspace(min(data(:)), max(data(:)), num_bins), 'DisplayStyle', 'stairs', 'DisplayName', species_label);
            
            hold on; % Superposition des histogrammes
        end
        
        % Ajoutez des étiquettes et une légende au graphique
        title(['Histogram for Variable ', num2str(i)]);
        xlabel('Value');
        ylabel('Frequency');
        legend('Location', 'best');
        
        hold off; % Terminez la superposition des histogrammes
    end
end
