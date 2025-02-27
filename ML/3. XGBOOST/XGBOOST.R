# Load libraries----
library(caret)
library(xgboost)  # Load the xgboost library

# Load datasets----
data <- read.csv("half.csv")
data <- data[, -1]
data$Potability <- as.factor(data$Potability)

# Split the data into training and testing sets----
set.seed(123) 
trainIndex <- createDataPartition(data$Potability, p = 0.7, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Convert data to matrix format for XGBoost
train_matrix <- as.matrix(trainData[, -ncol(trainData)])
train_labels <- as.numeric(trainData$Potability) - 1  # Convert factors to 0 and 1

test_matrix <- as.matrix(testData[, -ncol(testData)])
test_labels <- as.numeric(testData$Potability) - 1  # Convert factors to 0 and 1

# Train XGBoost model----
xgb_model <- xgboost(data = train_matrix, label = train_labels, 
                     objective = "binary:logistic", nrounds = 1000, 
                     eval_metric = "error", verbose = 0)

# Test model----
predictions <- predict(xgb_model, test_matrix)
predictions <- ifelse(predictions > 0.5, 1, 0)  # Convert probabilities to binary predictions

# Confusion matrix
conf_matrix <- confusionMatrix(factor(predictions), factor(test_labels))

# Display confusion matrix
print(conf_matrix)

