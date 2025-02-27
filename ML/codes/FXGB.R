# Load libraries ----
library(caret)
library(xgboost)

# Load datasets ----
data <- read.csv("half.csv")
data <- data[, -1]
data$Potability <- as.factor(data$Potability)

# Selected features ----
data <- data[, c("Potability", "Hardness", "Solids", "Chloramines", "Organic_carbon", "Trihalomethanes")]

# Ensure all selected features are numeric ----
data[, -1] <- lapply(data[, -1], as.numeric)

# Split the data into training and testing sets ----
set.seed(123) 
trainIndex <- createDataPartition(data$Potability, p = 0.7, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Convert data to matrix format for XGBoost ----
train_matrix <- as.matrix(trainData[, -1])
train_labels <- as.numeric(trainData$Potability) - 1  # Convert factors to 0 and 1

test_matrix <- as.matrix(testData[, -1])
test_labels <- as.numeric(testData$Potability) - 1  # Convert factors to 0 and 1

# Train XGBoost model with optimized parameters ----
xgb_model <- xgboost(data = train_matrix, label = train_labels, 
                     objective = "binary:logistic", 
                     nrounds = 150, 
                     max_depth = 4, 
                     eta = 0.3, 
                     gamma = 0, 
                     colsample_bytree = 0.8, 
                     min_child_weight = 1, 
                     subsample = 0.8, 
                     eval_metric = "error", 
                     verbose = 0)

# Test model ----
predictions <- predict(xgb_model, test_matrix)
predictions <- ifelse(predictions > 0.5, 1, 0)  # Convert probabilities to binary predictions

# Confusion matrix ----
conf_matrix <- confusionMatrix(factor(predictions), factor(test_labels))

# Display confusion matrix
print(conf_matrix)
