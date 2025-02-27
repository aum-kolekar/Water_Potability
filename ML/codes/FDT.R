# Libraries ----
library("rpart")
library("rpart.plot")
library("caret")

# Reading balanced data ----
data = read.csv("half.csv")
data = data[, -1]
data$Potability = as.factor(data$Potability)

#selected featuers
data = data[, c("Potability", "Hardness", "Solids", "Chloramines", "Organic_carbon", "Trihalomethanes")]

# Split data ----
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data = data[trainIndex, ]
test_data  = data[-trainIndex, ]

# Define tuning grid for cp only ----
tune_grid <- expand.grid(
  cp = c(0.01, 0.005, 0.001)  # Values of complexity parameter
)

# Define train control ----
train_control <- trainControl(method = "cv", number = 10)  # 10-fold cross-validation

# Train Decision Tree model with tuning ----
set.seed(123)
dt_tuned <- train(
  Potability ~ ., 
  data = train_data, 
  method = "rpart", 
  metric = "Accuracy", 
  tuneGrid = tune_grid,
  trControl = train_control,
  control = rpart.control(minsplit = 10, maxdepth = 15)  # Set fixed values for minsplit and maxdepth
)

# Display the best model and results ----
print(dt_tuned)
print(dt_tuned$bestTune)

# Plot the best Decision Tree ----
rpart.plot(dt_tuned$finalModel)

# Testing the model with test data ----
prediction = predict(dt_tuned, test_data[, -ncol(test_data)], type = "raw")

# Confusion matrix ----
cm = confusionMatrix(test_data$Potability, prediction)
print(cm)
