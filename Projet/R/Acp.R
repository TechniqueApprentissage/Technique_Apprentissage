#ACP
dim(data) 
View(data)
str(data)
-----------------------------------------------------------------------------------------------------------------------
#Preparation des donnéés

# Suppression des colonnes non nécessaires
data_clc <- data[,-c(1, 33)]  # Supprime la première colonne (id) et la dernière colonne (X)
# Codage de la variable 'diagnosis' si nécessaire
data$diagnosis <- as.factor(data$diagnosis)
# Sélectionner uniquement les colonnes quantitatives (si diagnosis est la deuxième colonne)
data_quantitative <- data_clc[, -1]  # Exclure la colonne de diagnostic

-----------------------------------------------------------------------------------------------------------------------
data_scaled <- scale(data_quantitative)
# Exécution de l'ACP
pca_result <- prcomp(data_scaled, center = TRUE, scale. = TRUE)

-----------------------------------------------------------------------------------------------------------------------
  # Variance expliquée
summary(pca_result)
plot(pca_result)  # Un scree plot pour visualiser la variance expliquée

# Visualisation des valeurs propres
  
plot(pca_result)
# Analyse des composantes principales
summary(pca_result)
# Biplot
biplot(pca_result)

# Transformation des données
data_pca <- as.data.frame(predict(pca_result))

plot(data_pca)
summary(data_pca)
-----------------------------------------------------------------------------------------------------------------------

# Assurez-vous que vous avez réalisé l'ACP sur votre jeu de données
pca_result <- prcomp(data_scaled, center = TRUE, scale. = TRUE)

# Calculer la variance expliquée
var_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2)

# Calculer la somme cumulée de la variance expliquée
cum_var_explained <- cumsum(var_explained)

# Trouver le nombre de composantes à retenir basé sur un seuil
# Par exemple, retenir les composantes qui contribuent à 95% de la variance expliquée
threshold <- 0.95
num_components <- which(cum_var_explained >= threshold)[1]

# Créer un Scree plot
plot(var_explained, xlab = "Principal Component", ylab = "Proportion of Variance Explained", type = "b")
abline(h = var_explained[num_components], col = "red", lty = 2)  # Ligne horizontale pour le seuil
abline(v = num_components, col = "red", lty = 2)  # Ligne verticale pour le nombre de composantes

# Utiliser les composantes retenues pour les analyses suivantes
data_pca_garde <- pca_result$x[, 1:num_components]

biplot(pca_result, cex = 0.8)  # 'cex' contrôle la taille des étiquettes




loadings <- data_pca$rotation
# Afficher les chargements pour les 10 premières composantes principales
loadings[, 1:10]

biplot(pca_result)






# En R
write.csv(data_pca, "data_pca.csv", row.names = FALSE)



# Standardiser les données
wdbc_scaled <- scale(data[, -c(diagnosis,id,X)])

# Exécution de l'ACP
wdbc_pca <- prcomp(wdbc_scaled)

# Visualisation des valeurs propres
plot(wdbc_pca)

# Interprétation des vecteurs propres
summary(wdbc_pca)
