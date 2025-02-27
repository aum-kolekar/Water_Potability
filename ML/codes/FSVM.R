# Libraries ----
library("e1071")
library("caret")

# Reading balanced data ----
data <- read.csv("half.csv")
data <- data[, -1]
data$Potability <- as.factor(data$Potability)

# Selected features ----
data <- data[, c("Potability", "Hardness", "Solids", "Chloramines", "Organic_carbon", "Trihalomethanes")]

# Split data ----
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data <- data[trainIndex, ]
test_data  <- data[-trainIndex, ]

# Tuning model using grid search ----
set.seed(123)
tune_result <- tune(
  svm,
  Potability ~ .,
  data = train_data,
  kernel = "radial",
    cost = 100,
    gamma = 1
)

# View tuning results ----
print(tune_result)
best_model <- tune_result$best.model
print(best_model)

# Testing model using test data ----
prediction <- predict(best_model, test_data[, -1])

# Confusion matrix ----
cm <- confusionMatrix(test_data[, "Potability"], prediction)
print(cm)
