# Load libraries----
library(caret)
library(xgboost)

# Load dataset----
data <- read.csv("half.csv")
data <- data[, -1]

# Ensure Potability is a factor with two levels----
data$Potability <- as.factor(data$Potability)

# Split the data into training and testing sets----
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.7, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Define tuning grid for XGBoost ----
tune_grid <- expand.grid(
  nrounds = c(50, 100),
  max_depth = c(3, 6),
  eta = c(0.1, 0.3),
  gamma = c(0, 0.1),
  colsample_bytree = c(0.8),
  min_child_weight = c(1, 5),
  subsample = c(0.8)
)


# Set up cross-validation ----
train_control <- trainControl(
  method = "cv", 
  number = 3,
  verboseIter = TRUE,
  allowParallel = TRUE
)

# Tune XGBoost model ----
set.seed(123)
xgb_tuned <- train(
  Potability ~ ., 
  data = trainData, 
  method = "xgbTree", 
  metric = "Accuracy", 
  tuneLength = 10,  # Randomly tries 10 different combinations
  trControl = train_control
)

# Display best model and results ----
print(xgb_tuned)
print(xgb_tuned$bestTune)

# Test tuned model ----
predictions <- predict(xgb_tuned, newdata = testData)

# Confusion matrix ----
conf_matrix <- confusionMatrix(predictions, testData$Potability)
print(conf_matrix)
