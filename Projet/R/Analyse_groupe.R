#---------------
#suppression de colonne :ID et X
data_clean <- subset(data, select = -c(id, X))
#convertor le colonne 'diagnosis' en facteur, puis en numérique
data_clean$diagnosis <- ifelse(data_clean$diagnosis == 'M', 1, 0)

--------------------------------------------------------------------

cor_matrix <- cor(data_clean)
# Afficher la matrice de corrélation
print(cor_matrix)
View(cor_matrix)
# Transformer la matrice de corrélation en format long pour ggplot2
# Installer le package reshape2 s'il n'est pas déjà installé
install.packages("reshape2")
# Charger le package reshape2
library(reshape2)
melted_cor_matrix <- melt(cor_matrix)
# Seuil pour la coloration en noir
seuil <- 0.8
# Créer la carte de chaleur
# Créer la carte de chaleur avec coloration conditionnelle
ggplot(data = melted_cor_matrix, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradientn(colors = c("blue", "white", "red", "black"),
                       values = scales::rescale(c(-1, 0, seuil, 1)),
                       breaks = c(-1, 0, seuil, 1),
                       labels = c("-1", "0", "0.7", "1")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 70, vjust = 1, hjust = 1),
        axis.text.y = element_text(angle = 0, vjust = 1, hjust = 1)) +
  coord_fixed()


library(reshape2)
melted_cor_matrix <- melt(cor_matrix)
# Seuil pour la coloration en noir
seuil <- -0.9
# Créer la carte de chaleur
# Créer la carte de chaleur avec coloration conditionnelle
ggplot(data = melted_cor_matrix, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradientn(colors = c("blue", "white", "red", "black"),
                       values = scales::rescale(c(-1, 0, seuil, 1)),
                       breaks = c(-1, 0, seuil, 1),
                       labels = c("-1", "0", "-0.7", "1")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 1),
        axis.text.y = element_text(angle = 0, vjust = 1, hjust = 1)) +
  coord_fixed()

--------------------------------------------------------------------------

# barplot des corrélations
  
ggplot(cor_df, aes(x = reorder(Variable, Correlation), y = Correlation)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(x = "Variable", y = "Correlation Avec Diagnosis") +
  coord_flip() # Retourner le graphique pour un meilleur affichage

# Barplot avec coloration conditionnelle COR>0;7
ggplot(cor_df, aes(x = reorder(Variable, Correlation), y = Correlation, fill = (Correlation > 0.7))) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("steelblue", "red")) +
  theme_minimal() +
  labs(x = "Variable", y = "Correlation Avec Diagnosis") +
  coord_flip() # Retourner le graphique pour un meilleur affichage

# # Analyse :

# # Recherche supplémentaire : Pour les variables faiblement corrélées, il serait intéressant 
# d'explorer pourquoi elles n'ont pas une forte corrélation avec 'diagnosis'. Cela pourrait
# être dû à la nature de la mesure, à la variabilité biologique, ou à la possibilité que ces
# caractéristiques ne soient pas pertinentes pour différencier les cas bénins des cas malins.
# # 
# # Évaluation clinique : Bien que les corrélations fortes indiquent des relations importantes,
# elles ne confirment pas la causalité. Des études cliniques supplémentaires 
# seraient nécessaires pour évaluer si ces relations sont causales ou simplement associatives.
# # 
# # Prudence dans l'interprétation : Enfin, il est important de ne pas trop s'appuyer 
# uniquement sur la force des corrélations lors de la prise de décisions cliniques. 
# D'autres facteurs tels que la compréhensibilité clinique, la faisabilité des mesures,
# et les connaissances biologiques doivent également être pris en compte.
---------------------------------------------------------------------------
#partager le data en 3 groupe pour etudier chaque groupe a part 
# Sélectionner les variables pour chaque groupe + diagnosis
data_mean <- data[grep("mean", names(data))]
data_mean$diagnosis <- data$diagnosis

data_se <- data[grep("se", names(data))]
data_se$diagnosis <- data$diagnosis

data_worst <- data[grep("worst", names(data))]
data_worst$diagnosis <- data$diagnosis


#calcul de coereltion
data$diagnosis_num <- as.numeric(data$diagnosis == "M")
cor(data_mean[,-ncol(data_mean)], data$diagnosis_num)
# Pour le groupe des erreurs standard
cor(data_se[,-ncol(data_se)], data$diagnosis_num)
# Pour le groupe des pires valeurs
cor(data_worst[,-ncol(data_worst)], data$diagnosis_num)

library(dplyr)

# Calcul de la corrélation pour chaque groupe et création d'un tableau
cor_mean <- cor(data_mean[,-ncol(data_mean)], data$diagnosis_num)
cor_se <- cor(data_se[,-ncol(data_se)], data$diagnosis_num)
cor_worst <- cor(data_worst[,-ncol(data_worst)], data$diagnosis_num)

# Convertir en data.frame et ordonner
df_mean <- data.frame(variable = names(cor_mean), correlation = cor_mean) %>%
  arrange(desc(abs(correlation)))

df_se <- data.frame(variable = names(cor_se), correlation = cor_se) %>%
  arrange(desc(abs(correlation)))

df_worst <- data.frame(variable = names(cor_worst), correlation = cor_worst) %>%
  arrange(desc(abs(correlation)))

# Affichage des tableaux
print(df_mean)
print(df_se)
print(df_worst)

# Groupe des means (Moyenne)
      # Les variables :concave.points_mean, perimeter_mean, radius_mean, et area_mean :
      # montrent les corrélations les plus fortes avec la variable cible diagnosis. 
      # Cela suggère que les caractéristiques liées à la forme et à la taille des cellules sont des indicateurs significatifs 
      # de la malignité d'une tumeur.
      #  La texture, la douceur, la symétrie, et la dimension fractale, bien que corrélées, 
      # ont des coefficients de corrélation plus faibles, suggérant un impact moindre sur la prédiction de la malignité par
      # rapport aux caractéristiques de forme et de taille.
      # La dimension fractale moyenne présente une corrélation négative très faible, ce qui indique qu'elle n'est pas un 
      # bon prédicteur de la malignité dans ce contexte.

# Groupe des se (Erreurs Standard)
      # Les variables liées à la taille (radius_se, perimeter_se, et area_se) montrent également une corrélation positive 
      # significative avec la malignité, bien que généralement moins forte que dans le groupe des moyennes.
      # La variable concave.points_se montre également une corrélation notable, ce qui suggère que la variabilité dans 
      # la présence de points concaves peut être un indicateur de malignité.
      # La texture et la symétrie ont peu ou pas de corrélation avec la malignité dans ce groupe, ce qui renforce l'idée que
      # ces caractéristiques sont moins importantes pour prédire la malignité.

# Groupe des worst (Pires Valeurs)
      # Ce groupe montre les plus fortes corrélations pour des variables telles que :
      # perimeter_worst, area_worst, radius_worst, et concave.points_worst, 
      # ce qui indique que les caractéristiques maximales ou "pires" observées dans les cellules sont des prédicteurs très 
      # forts de la malignité.
      # Concavity_worst et compactness_worst montrent également des corrélations significatives, ce qui suggère que 
      # les aspects plus agressifs de la morphologie cellulaire sont particulièrement importants pour distinguer les tumeurs malignes.
      # Les variables de texture et de symétrie restent des prédicteurs moins forts par rapport aux variables liées à 
      #la forme et à la taille, même dans le pire des cas.

#---------------
#regression lineaire
#visualisation apres lanalyse de groupe :
#dapres les coeleation faite sur chaque groupe avec la var Diagnosis
#je veu etudier les var qui sont le plus coreler avec diagnosis pour chaque groupe
# Groupe des means:concave.points_mean, perimeter_mean, radius_mean, et area_mean
# concave.points_mean0.7766138
# perimeter_mean0.7426355
# radius_mean0.7300285
# area_mean0.7089838

#Groupe des worst (Pires Valeurs):perimeter_worst, area_worst, radius_worst, et concave.points_worst

#Groupe Means
# Pour 'radius_mean' vs 'diagnosis'
ggplot(data, aes(x=radius_mean, y=diagnosis)) +
  geom_jitter(aes(color=diagnosis), width=0.2) +
  labs(title="Radius Mean vs Diagnosis", x="Radius Mean", y="Diagnosis") +
  theme_minimal()
# Pour 'concave.points_mean' vs 'diagnosis'
ggplot(data, aes(x=concave.points_mean, y=diagnosis)) +
  geom_jitter(aes(color=diagnosis), width=0.2) +
  labs(title="concave.points_mean vs Diagnosis", x="concave.points_mean", y="Diagnosis") +
  theme_minimal()
# Pour 'texture_mean' vs 'diagnosis'
ggplot(data, aes(x=texture_mean, y=diagnosis)) +
  geom_jitter(aes(color=diagnosis), width=0.2) +
  labs(title="Texture Mean vs Diagnosis", x="Texture Mean", y="Diagnosis") +
  theme_minimal()
# Pour 'perimeter_mean' vs 'diagnosis'
ggplot(data, aes(x=perimeter_mean, y=diagnosis)) +
  geom_jitter(aes(color=diagnosis), width=0.2) +
  labs(title="perimeter_mean vs Diagnosis", x="perimeter_mean", y="Diagnosis") +
  theme_minimal()

#Groupe des worst
ggplot(data, aes(x=perimeter_worst, y=diagnosis)) +
  geom_jitter(aes(color=diagnosis), width=0.2) +
  labs(title="perimeter_worst vs Diagnosis", x="perimeter_worst", y="Diagnosis") +
  theme_minimal()

ggplot(data, aes(x=radius_worst, y=diagnosis)) +
  geom_jitter(aes(color=diagnosis), width=0.2) +
  labs(title="radius_worst vs Diagnosis", x="radius_worst", y="Diagnosis") +
  theme_minimal()


ggplot(data, aes(x=area_worst, y=diagnosis)) +
  geom_jitter(aes(color=diagnosis), width=0.2) +
  labs(title="area_worst vs Diagnosis", x="area_worst", y="Diagnosis") +
  theme_minimal()

ggplot(data, aes(x=concave.points_worst, y=diagnosis)) +
  geom_jitter(aes(color=diagnosis), width=0.2) +
  labs(title="concave.points_worst vs Diagnosis", x="concave.points_worst", y="Diagnosis") +
  theme_minimal()
------------------------------------------------------------------------------------
# sous-ensemble de données pour l'analyse
sub_data <- data[c("radius_mean", "texture_mean", "perimeter_mean", "concave.points_mean","diagnosis")]
# Utiliser ggpairs pour afficher les relations
ggpairs(sub_data, mapping=ggplot2::aes(color=diagnosis))

# sous-ensemble de données pour l'analyse
sub_data <- data[c("perimeter_worst", "radius_worst", "area_worst", "concave.points_worst","diagnosis")]
# Utiliser ggpairs pour afficher les relations
ggpairs(sub_data, mapping=ggplot2::aes(color=diagnosis))

#Regression avec le groupe Means
# Charger la bibliothèque caret pour la division des données
library(caret)
# Définir une graine aléatoire pour la reproductibilité
set.seed(123)
# Diviser les données en ensembles d'entraînement et de test (80% train, 20% test)
index <- createDataPartition(data$diagnosis_num, p=0.8, list=FALSE)
trainData <- data[index, ]
testData <- data[-index, ]
# Charger la bibliothèque stats pour glm()
library(stats)
# Construire le modèle sur l'ensemble d'entraînement
model <- glm(diagnosis_num ~ radius_mean + texture_mean + perimeter_mean, data = trainData, family = "binomial")
# Voir le résumé du modèle
summary(model)
# Prédire les probabilités sur l'ensemble de test
predicted_probs <- predict(model, newdata = testData, type = "response")
# Convertir les probabilités en prédictions binaires (0 ou 1 basé sur un seuil de 0.5)
predicted_class <- ifelse(predicted_probs > 0.5, 1, 0)
# Calculer la matrice de confusion
confusionMatrix <- table(Predicted = predicted_class, Actual = testData$diagnosis_num)
# Afficher la matrice de confusion
print(confusionMatrix)

# Calculer et afficher l'AUC-ROC
library(pROC)
roc_obj <- roc(testData$diagnosis_num, predicted_probs)
auc_value <- auc(roc_obj)
print(paste("AUC:", auc_value))

#Regression avec le groupe worst
# Charger la bibliothèque stats pour glm()
library(stats)
# Construire le modèle sur l'ensemble d'entraînement
model <- glm(diagnosis_num ~ radius_worst + perimeter_worst + area_worst, data = trainData, family = "binomial")
# Voir le résumé du modèle
summary(model)
# Prédire les probabilités sur l'ensemble de test
predicted_probs <- predict(model, newdata = testData, type = "response")
# Convertir les probabilités en prédictions binaires (0 ou 1 basé sur un seuil de 0.5)
predicted_class <- ifelse(predicted_probs > 0.5, 1, 0)
# Calculer la matrice de confusion
confusionMatrix <- table(Predicted = predicted_class, Actual = testData$diagnosis_num)
# Afficher la matrice de confusion
print(confusionMatrix)

# Calculer et afficher l'AUC-ROC
library(pROC)
roc_obj <- roc(testData$diagnosis_num, predicted_probs)
auc_value <- auc(roc_obj)
print(paste("AUC:", auc_value))


#TOUT les donness
# Supprimer les colonnes 'X' et 'id' du dataframe
data_modifie <- data[, !(names(data) %in% c("X", "id"))]
# Exécuter le modèle de régression linéaire sans les colonnes 'X' et 'id'
model_global <- lm(diagnosis_num ~ ., data = data_modifie)
summary(model_global)
# Diagramme de dispersion des résidus
plot(model_global$residuals, ylab = "Résidus", xlab = "Valeurs prédites", main = "Résidus vs. Valeurs prédites")
abline(h = 0, col = "red")

# Vérification de la normalité des résidus
hist(model_global$residuals, main = "Histogramme des résidus", xlab = "Résidus")

# Calcul du R² ajusté
summary(model_global)$adj.r.squared

# Calcul du RMSE
rmse <- sqrt(mean(model_global$residuals^2))
rmse
# Exemple de validation croisée K-fold avec la bibliothèque 'caret'
library(caret)
set.seed(123) # Pour la reproductibilité
train_control <- trainControl(method = "cv", number = 10) # 10-fold CV
model_cv <- train(diagnosis_num ~ ., data = data_modifie, method = "lm", trControl = train_control)
print(model_cv)
# Supposons que 'data_test' est votre ensemble de test
predictions <- predict(model_global, newdata = testData)
# Calculer des métriques de performance, e.g., RMSE, R²

#---------------
# Exemple de fonction pour effectuer ANOVA sur toutes les variables d'un dataframe
perform_anova_on_group <- function(data_group) {
  results <- list()
  for (var in names(data_group)[-which(names(data_group) == "diagnosis")]) {
    formula <- as.formula(paste(var, "~ diagnosis"))
    anova_result <- summary(aov(formula, data = data_group))
    results[[var]] <- anova_result
  }
  return(results)
}

# Appliquer la fonction à chaque groupe
results_mean <- perform_anova_on_group(data_mean)
results_se <- perform_anova_on_group(data_se)
results_worst <- perform_anova_on_group(data_worst)


create_histograms <- function(data_group, group_name) {
  # Identifier toutes les variables à l'exception de 'diagnosis'
  variables <- setdiff(names(data_group), "diagnosis")
  
  # Parcourir chaque variable et créer un histogramme
  for (var in variables) {
    p <- ggplot(data_group, aes_string(x = var, fill = "diagnosis")) +
      geom_histogram(position = "identity", alpha = 0.5, bins = 30) +
      labs(title = paste("Distribution of", var, "in", group_name, "Group"),
           x = var,
           y = "Frequency") +
      scale_fill_brewer(palette = "Set1") +
      theme_minimal()
    
    print(p)
  }
}


create_histograms(data_mean, "Mean")
create_histograms(data_se, "SE")
create_histograms(data_worst, "Worst")





#coeraltion
# Supposer que 'data' est votre dataframe
data_for_correlation <- data %>%
  select(-id, -diagnosis, -X) %>%
  select_if(is.numeric) # S'assurer de ne garder que les colonnes numériques

# Calculer la matrice de corrélation
cor_matrix <- cor(data_for_correlation, use = "complete.obs")

# Afficher la matrice de corrélation
print(cor_matrix)




library(reshape2) # Charger le package reshape2 pour la fonction melt()
# Transformer la matrice de corrélation en format long
cor_melt <- melt(cor_matrix)
library(ggplot2)
# Créer une heatmap de la matrice de corrélation
ggplot(data = cor_melt, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() + # Utiliser des tuiles pour la heatmap
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, limit = c(-1, 1), name = "Corrélation") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1), # Ajuster l'angle du texte de l'axe X pour améliorer la lisibilité
        axis.title = element_blank()) + # Supprimer les titres des axes
  labs(fill = "Corrélation") # Légende pour l'échelle de couleurs
#---------------------
# Supposons que votre ensemble de données s'appelle data et qu'il contient uniquement des variables quantitatives
# Vous devez également standardiser vos données avant d'appliquer PCA

colonnes_a_exclure <- c("id", "diagnosis", "X") 
data_sans_exclus <- data[, !names(data) %in% colonnes_a_exclure, drop = FALSE]

# 1. Standardisation des données
data_standardized <- scale(data_sans_exclus)

# 2. Application de PCA
pca_result <- prcomp(data_standardized, scale = TRUE)

# 3. Visualisation de la proportion de variance expliquée par chaque composante
summary(pca_result)

# 4. Graphique de la variance expliquée cumulative
plot(cumsum(pca_result$sdev^2) / sum(pca_result$sdev^2), xlab = "Nombre de composantes",
     ylab = "Proportion de variance expliquée",
     main = "Variance expliquée cumulative")

# 5. Choix du nombre de composantes
# Vous pouvez choisir le nombre de composantes en fonction de la proportion de variance expliquée
# ou en utilisant des critères tels que le coude dans le graphique de la variance expliquée cumulative

# 6. Projection des données dans l'espace des composantes principales
data_pca <- as.data.frame(predict(pca_result))

# Vous pouvez utiliser data_pca pour effectuer d'autres analyses
