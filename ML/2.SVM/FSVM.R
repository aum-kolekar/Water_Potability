# Load libraries----
library(e1071)
library(caret)

# Load datasets----
data <- read.csv("half.csv")
data <- data[, c("Potability", "Hardness", "Solids", "Chloramines", "Organic_carbon", "Trihalomethanes")]
data$Potability <- as.factor(data$Potability)

# Split the data into training and testing sets----
set.seed(123) 
trainIndex <- createDataPartition(data$Potability, p = 0.7, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Train model with selected features----
svm_model <- svm(Potability ~ ., data = trainData, kernel = "radial")

# Test model----
predictions <- predict(svm_model, testData)
conf_matrix <- confusionMatrix(predictions, testData$Potability)

# Display confusion matrix
print(conf_matrix)

