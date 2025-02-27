# Load libraries----
library(e1071)
library(caret)

# Load datasets----
data <- read.csv("half.csv")
data <- data[, -1]
data$Potability <- as.factor(data$Potability)

# Split the data into training and testing sets----
set.seed(123) 
trainIndex <- createDataPartition(data$Potability, p = 0.7, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# train model----
svm_model <- svm(Potability ~ ., data = trainData, kernel = "radial")

# test mpdel----
predictions <- predict(svm_model, testData)
conf_matrix <- confusionMatrix(predictions, testData$Potability)

# Display confusion matrix
print(conf_matrix)
