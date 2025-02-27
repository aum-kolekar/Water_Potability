# Libraries ----
library("rpart.plot")
library("rpart")
library("caret")

# Reading balanced 50:50 sampled data----
data <- read.csv("half.csv")
data <- data[, -1]
data$Potability <- as.factor(data$Potability)

# Split data
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data <- data[trainIndex, ]
test_data  <- data[-trainIndex, ]

# Building model using selected features ----
model <- rpart(Potability ~ Hardness + Solids + Chloramines + Organic_carbon + Trihalomethanes, 
               data = train_data, 
               control = list(cp = 0.000001, minsplit = 10, minbucket = 10, xval = 7, maxdepth = 15))

# Plot the decision tree
rpart.plot(model)

# Testing model ----
set.seed(10)
prediction <- predict(model, test_data[, c("Hardness", "Solids", "Chloramines", "Organic_carbon", "Trihalomethanes")], type = "class")

# Confusion Matrix
cm <- confusionMatrix(test_data$Potability, prediction)
print(cm)
