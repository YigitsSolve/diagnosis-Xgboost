library(xgboost)
library(readr)
anemi <- read_csv("C:/Users/Desmer/Desktop/Çalışmalar/diagnosed_cbc_data_v4.csv")
missing_anemi <- colSums(is.na(anemi))
missing_anemi


# Gerekli kütüphaneleri yükleyin
library(ggplot2)
library(gridExtra)


# Her bir değişken için histogram oluşturma
histogram_wbc <- ggplot(anemi, aes(x = WBC)) +
  geom_histogram(fill = "skyblue", color = "black") +
  labs(x = "WBC", y = "Frekans", title = "WBC Dağılımı") +
  theme_minimal()

histogram_lymp <- ggplot(anemi, aes(x = LYMp)) +
  geom_histogram(fill = "lightgreen", color = "black") +
  labs(x = "LYMp", y = "Frekans", title = "LYMp Dağılımı") +
  theme_minimal()

histogram_neutp <- ggplot(anemi, aes(x = NEUTp)) +
  geom_histogram(fill = "lightblue", color = "black") +
  labs(x = "NEUTp", y = "Frekans", title = "NEUTp Dağılımı") +
  theme_minimal()

histogram_lymn <- ggplot(anemi, aes(x = LYMn)) +
  geom_histogram(fill = "lightgreen", color = "black") +
  labs(x = "LYMn", y = "Frekans", title = "LYMn Dağılımı") +
  theme_minimal()

histogram_neutn <- ggplot(anemi, aes(x = NEUTn)) +
  geom_histogram(fill = "lightblue", color = "black") +
  labs(x = "NEUTn", y = "Frekans", title = "NEUTn Dağılımı") +
  theme_minimal()

histogram_rbc <- ggplot(anemi, aes(x = RBC)) +
  geom_histogram(fill = "skyblue", color = "black") +
  labs(x = "RBC", y = "Frekans", title = "RBC Dağılımı") +
  theme_minimal()

histogram_hgb <- ggplot(anemi, aes(x = HGB)) +
  geom_histogram(fill = "lightgreen", color = "black") +
  labs(x = "HGB", y = "Frekans", title = "HGB Dağılımı") +
  theme_minimal()

histogram_hct <- ggplot(anemi, aes(x = HCT)) +
  geom_histogram(fill = "lightblue", color = "black") +
  labs(x = "HCT", y = "Frekans", title = "HCT Dağılımı") +
  theme_minimal()

histogram_mcv <- ggplot(anemi, aes(x = MCV)) +
  geom_histogram(fill = "skyblue", color = "black") +
  labs(x = "MCV", y = "Frekans", title = "MCV Dağılımı") +
  theme_minimal()

histogram_mch <- ggplot(anemi, aes(x = MCH)) +
  geom_histogram(fill = "lightgreen", color = "black") +
  labs(x = "MCH", y = "Frekans", title = "MCH Dağılımı") +
  theme_minimal()

histogram_mchc <- ggplot(anemi, aes(x = MCHC)) +
  geom_histogram(fill = "lightblue", color = "black") +
  labs(x = "MCHC", y = "Frekans", title = "MCHC Dağılımı") +
  theme_minimal()

histogram_plt <- ggplot(anemi, aes(x = PLT)) +
  geom_histogram(fill = "skyblue", color = "black") +
  labs(x = "PLT", y = "Frekans", title = "PLT Dağılımı") +
  theme_minimal()

histogram_pdw <- ggplot(anemi, aes(x = PDW)) +
  geom_histogram(fill = "lightgreen", color = "black") +
  labs(x = "PDW", y = "Frekans", title = "PDW Dağılımı") +
  theme_minimal()

histogram_pct <- ggplot(anemi, aes(x = PCT)) +
  geom_histogram(fill = "lightblue", color = "black") +
  labs(x = "PCT", y = "Frekans", title = "PCT Dağılımı") +
  theme_minimal()

histogram_diagnosis <- ggplot(anemi, aes(x = Diagnosis)) +
  geom_bar(fill = "orange", color = "black") +
  labs(x = "Diagnosis", y = "Frekans", title = "Diagnosis Dağılımı") +
  theme_minimal()

# Histogramları birleştirme ve ekrana bastırma
combined_plots <- grid.arrange(histogram_wbc, histogram_lymp, histogram_neutp, histogram_lymn,
                               histogram_neutn, histogram_rbc, histogram_hgb, histogram_hct,
                               histogram_mcv, histogram_mch, histogram_mchc, histogram_plt,
                               histogram_pdw, histogram_pct, histogram_diagnosis,
                               ncol = 3)

print(combined_plots)

summary(anemi)
library(corrplot)
# Sayısal değişkenlerin seçilmesi (korelasyon matrisi için)
numeric_vars <- anemi[, sapply(anemi, is.numeric)]

# Korelasyon matrisini hesaplama
cor_matrix <- cor(numeric_vars, use = "complete.obs")

# Korelasyon matrisini görselleştirme
corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45, 
         addCoef.col = "black", number.cex = 0.7, col = colorRampPalette(c("blue", "white", "red"))(200),
         title = "Korelasyon Matrisi", mar = c(0, 0, 2, 0))

anemi$Diagnosis

# "Diagnosis" değişkenini faktör olarak ayarlama
anemi$Diagnosis <- as.factor(anemi$Diagnosis)

# Eğitim ve test veri setlerini oluşturma
set.seed(123)
trainIndex <- createDataPartition(anemi$Diagnosis, p = 0.5, list = FALSE)
trainData <- anemi[trainIndex, ]
testData <- anemi[-trainIndex, ]

# XGBoost'un veri formatına uygun hale getirme
train_matrix <- xgb.DMatrix(data = as.matrix(trainData[, -which(names(trainData) == "Diagnosis")]), label = as.numeric(trainData$Diagnosis) - 1)
test_matrix <- xgb.DMatrix(data = as.matrix(testData[, -which(names(testData) == "Diagnosis")]), label = as.numeric(testData$Diagnosis) - 1)

# XGBoost parametrelerini ayarlama
params <- list(
  objective = "multi:softprob",
  eval_metric = "mlogloss",
  num_class = length(levels(trainData$Diagnosis))
)

# XGBoost modelini eğitme
xgb_model <- xgboost(
  params = params,
  data = train_matrix,
  nrounds = 100,
  max_depth = 1,
  verbose = 0
)


# Test veri setinde tahminler yapma
predictions <- predict(xgb_model, newdata = test_matrix)
predictions <- matrix(predictions, ncol = length(levels(trainData$Diagnosis)), byrow = TRUE)
predicted_classes <- max.col(predictions) - 1

# Tahminleri ve gerçek değerleri faktör seviyeleriyle eşleştirme
predicted_classes <- factor(predicted_classes, levels = 0:(length(levels(trainData$Diagnosis)) - 1), labels = levels(trainData$Diagnosis))

# Karışıklık matrisini oluşturma ve yazdırma
confusionMatrix(predicted_classes, testData$Diagnosis)


######################


# Gerekli kütüphaneleri yükleyin
library(readr)
library(caret)
library(xgboost)
library(ggplot2)
library(gridExtra)
library(dplyr)

# Model sonuçlarınızı ve performans metriklerini saklayın
accuracy <- 0.9821
kappa <- 0.9656
sensitivity <- c(Healthy = 0.9552, Iron_deficiency_anemia = 0.9730, Leukemia = 0.8889, Leukemia_with_thrombocytopenia = 1.0000, Macrocytic_anemia = 1.0000, Normocytic_hypochromic_anemia = 1.0000, Normocytic_normochromic_anemia = 0.9623, Other_microcytic_anemia = 1.0000, Thrombocytopenia = 1.0000)
specificity <- c(Healthy = 0.9946, Iron_deficiency_anemia = 1.0000, Leukemia = 1.0000, Leukemia_with_thrombocytopenia = 0.9920, Macrocytic_anemia = 1.0000, Normocytic_hypochromic_anemia = 1.0000, Normocytic_normochromic_anemia = 1.0000, Other_microcytic_anemia = 0.9833, Thrombocytopenia = 1.0000)

# Performans metriklerini veri çerçevesine dönüştürün
metrics_df <- data.frame(
  Class = names(sensitivity),
  Sensitivity = sensitivity,
  Specificity = specificity
)

# Sensitivity grafiği
sensitivity_plot <- ggplot(metrics_df, aes(x = reorder(Class, -Sensitivity), y = Sensitivity)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(title = "Sensitivity by Class", x = "Class", y = "Sensitivity") +
  theme_minimal()

# Specificity grafiği
specificity_plot <- ggplot(metrics_df, aes(x = reorder(Class, -Specificity), y = Specificity)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  coord_flip() +
  labs(title = "Specificity by Class", x = "Class", y = "Specificity") +
  theme_minimal()

# Doğruluk ve Kappa Değeri İçin Metin Grafiği
accuracy_kappa_df <- data.frame(
  Metric = c("Accuracy", "Kappa"),
  Value = c(accuracy, kappa)
)

accuracy_kappa_plot <- ggplot(accuracy_kappa_df, aes(x = Metric, y = Value)) +
  geom_bar(stat = "identity", fill = c("lightblue", "lightcoral")) +
  geom_text(aes(label = round(Value, 4)), vjust = -0.3) +
  labs(title = "Overall Model Performance", x = "Metric", y = "Value") +
  ylim(0, 1) +
  theme_minimal()

# Grafikleri birleştirin
combined_plot <- grid.arrange(sensitivity_plot, specificity_plot, accuracy_kappa_plot, ncol = 1)

# Grafikleri ekrana bastırma
print(combined_plot)

