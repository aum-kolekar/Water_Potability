#libraries ----
library("randomForest")
library("caret")

#reading balanced data----
data = read.csv("half.csv")
data = data[, -1]
data$Potability = as.factor(data$Potability)

#selected featuers
data = data[, c("Potability", "Hardness", "Solids", "Chloramines", "Organic_carbon", "Trihalomethanes")]

#split data
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data = data[trainIndex, ]
test_data  = data[-trainIndex, ]

# Define tuning grid for Random Forest (only mtry)
tune_grid <- expand.grid(
  mtry = c(2, 3, 4)  # Test different values for mtry only
)

# Define train control
train_control <- trainControl(method = "cv", number = 10)  # 10-fold cross-validation

# Train Random Forest model with caret's train() and tune mtry
set.seed(123)
rf_tuned <- train(
  Potability ~ ., 
  data = train_data, 
  method = "rf", 
  metric = "Accuracy", 
  tuneGrid = tune_grid,
  trControl = train_control,
  ntree = 200  # Set ntree directly here
)

# Display the best model and results
print(rf_tuned)
print(rf_tuned$bestTune)

#testing model using test data----
best_model <- rf_tuned$finalModel
prediction = predict(best_model, test_data[, -10])

# Confusion matrix
cm = confusionMatrix(test_data$Potability, prediction)
print(cm)
