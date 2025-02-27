# Load libraries ----
library(caret)
library(class)

# Reading balanced 50:50 sampled data ----
data <- read.csv("half.csv")
data <- data[, -1]
data$Potability <- as.factor(data$Potability)

# Split data ----
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data <- data[trainIndex, ]
test_data <- data[-trainIndex, ]

# Separate features and labels ----
train_features <- train_data[, -10]  # Exclude Potability column
train_labels <- train_data[, 10]     # Potability column as labels
test_features <- test_data[, -10]
test_labels <- test_data[, 10]

# Tune 'k' by testing multiple values ----
best_k <- 1
best_accuracy <- 0

for (k in 1:20) {
  # Perform KNN prediction
  predictions <- knn(train = train_features, test = test_features, cl = train_labels, k = k)
  
  # Calculate accuracy
  accuracy <- sum(diag(table(test_labels, predictions))) / nrow(test_data)
  
  # Print accuracy for current k
  print(paste("k =", k, "Accuracy =", round(accuracy * 100, 2), "%"))
  
  # Update best k if this k has higher accuracy
  if (accuracy > best_accuracy) {
    best_accuracy <- accuracy
    best_k <- k
  }
}

# Print the best k and corresponding accuracy ----
print(paste("Best k =", best_k, "with Accuracy =", round(best_accuracy * 100, 2), "%"))

# Final model using the best k ----
final_predictions <- knn(train = train_features, test = test_features, cl = train_labels, k = best_k)

# Confusion matrix ----
cm <- confusionMatrix(test_labels, final_predictions)
print(cm)
