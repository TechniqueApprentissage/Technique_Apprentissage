% Définition de la fonction groupStatistics
function groupStatistics(data, labels)
    unique_labels = unique(labels);
    num_groups = length(unique_labels);

    for i = 1:num_groups
        group_label = unique_labels(i);
        group_data = data(labels == group_label, :); % Données pour le groupe actuel

        fprintf('Group: %s\n', group_label);
        fprintf('Total data points: %d\n', size(group_data, 1));
        fprintf('Sum: %f\n', sum(group_data));
        fprintf('Minimum: %f\n', min(group_data));
        fprintf('Maximum: %f\n', max(group_data));
        fprintf('Variance: %f\n', var(group_data));
        fprintf('Ecart-type: %f\n', std(group_data));
    end
end

