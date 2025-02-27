# Load libraries
library(caret)
library(class)

# Read and prepare data
data = read.csv("half.csv")
data = data[, -1]
data$Potability = as.factor(data$Potability)

# Split data
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data = data[trainIndex, ]
test_data  = data[-trainIndex, ]

# Define training control
train_control <- trainControl(method = "cv", number = 10)  # 10-fold cross-validation

# Define tuning grid for k values
tune_grid <- expand.grid(k = seq(1, 15, by = 2))  # Adjust range as needed

# Train the model with tuning
set.seed(123)
tuned_model <- train(Potability ~ ., 
                     data = train_data, 
                     method = "knn", 
                     trControl = train_control, 
                     tuneGrid = tune_grid)

# Print the best k and results
print(tuned_model)
best_k <- tuned_model$bestTune$k
cat("Best k value:", best_k, "\n")

# Evaluate on test data with the best k
final_model <- knn(train_data[, -10], test_data[, -10], train_data[, 10], k = best_k)
cm = confusionMatrix(test_data[, 10], final_model)
print(cm)
