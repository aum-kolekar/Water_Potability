# Libraries ----
library(randomForest)
library(caret)

# Load processed data and train final model ----
processed_data <- read.csv("half.csv")
processed_data <- processed_data[, -1]
processed_data$Potability <- as.factor(processed_data$Potability)

set.seed(123)
trainIndex <- createDataPartition(processed_data$Potability, p = 0.9, list = FALSE)
train_data <- processed_data[trainIndex, ]

# Train the Random Forest model with optimal parameters
best_rf_model <- randomForest(
  Potability ~ ., 
  data = train_data, 
  mtry = 3, 
  ntree = 200
)
