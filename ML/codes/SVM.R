#libraries ----
library("e1071")
library("caret")

#reading balanced 50:50 sampled data----
data = read.csv("half.csv")
data = data[, -1]
data$Potability = as.factor(data$Potability)

#split data
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data = data[trainIndex, ]
test_data  = data[-trainIndex, ]

#tuning model using grid search----
set.seed(123)
tune_result <- tune(
  svm,
  Potability ~ .,
  data = train_data,
  kernel = "radial",  # Radial kernel; change if you'd like to try others
  ranges = list(
    cost = c(0.1, 1, 10, 100),
    gamma = c(0.001, 0.01, 0.1, 1)
  )
)

# View tuning results
print(tune_result)
best_model <- tune_result$best.model
print(best_model)

#testing model using test data----
prediction = predict(best_model, test_data[, -10])

# Confusion matrix
cm = confusionMatrix(test_data[, 10], prediction)
print(cm)