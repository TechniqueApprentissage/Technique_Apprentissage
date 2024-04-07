% Dans analyserGroupes.m
function analyserGroupes(data, etiquettes)
    uniqueEtiquettes = unique(etiquettes);
    numGroupes = length(uniqueEtiquettes);

    for i = 1:numGroupes
        groupeData = data(etiquettes == uniqueEtiquettes(i), :);
        fprintf('Analyse pour le groupe %d:\n', uniqueEtiquettes(i));

       
        %analyse de moyennes et d'écart-types pour chaque variable
        moyennes = mean(groupeData);
        ecartsTypes = std(groupeData);
        fprintf('Moyennes des variables:\n');
        disp(moyennes);
        fprintf('Écart-types des variables:\n');
        disp(ecartsTypes);

        
    end
end




