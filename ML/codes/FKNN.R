#library ----
library(caret)
library(class)


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



#build model ----
set.seed(123)
model = knn(train_data[, -10], test_data[, -10], train_data[, 10], k=1)

#confusion metrics----
cm = confusionMatrix(test_data[, 10], model)
print(cm)


# Library ----
library(caret)
library(class)

# Reading balanced data ----
data = read.csv("half.csv")
data = data[, -1]
data$Potability = as.factor(data$Potability)

# Selected features ----
data = data[, c("Potability", "Hardness", "Solids", "Chloramines", "Organic_carbon", "Trihalomethanes")]

# Split data ----
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data = data[trainIndex, ]
test_data  = data[-trainIndex, ]

# Build KNN model ----
set.seed(123)
model = knn(
  train = train_data[, -1],  # All columns except Potability
  test = test_data[, -1],    # All columns except Potability
  cl = train_data$Potability,  # Potability column as the target variable
  k = 1
)

# Confusion matrix ----
cm = confusionMatrix(test_data$Potability, model)
print(cm)
