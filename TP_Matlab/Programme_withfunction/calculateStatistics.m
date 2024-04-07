function calculateStatistics(data)
    % Input: data - Une matrice où chaque colonne représente une variable
    
    num_variables = size(data, 2); % Nombre de variables
    fprintf('Total number of variables: %d\n', num_variables);

    for i = 1:num_variables
        variable = data(:, i); % Extrait la i-ème colonne de données

        fprintf('Variable %d:\n', i);
        fprintf('Total data points: %d\n', length(variable));
        fprintf('Sum: %f\n', sum(variable));
        fprintf('Minimum: %f\n', min(variable));
        fprintf('Maximum: %f\n', max(variable));
        fprintf('Variance: %f\n', var(variable));
        fprintf('Ecart-type: %f\n', std(variable));
        
        fprintf('\n'); % Laissez un espace entre chaque variable
    end
end
