#library ----
library(caret)
library(class)


#reading balanced data----
data = read.csv("half.csv")
data = data[, -1]
data$Potability = as.factor(data$Potability)

#split data
set.seed(123)
trainIndex <- createDataPartition(data$Potability, p = 0.9, list = FALSE)
train_data = data[trainIndex, ]
test_data  = data[-trainIndex, ]



#build model ----
model = knn(train_data[, -10], test_data[, -10], train_data[, 10], k=1)

#confusion metrics----
cm = confusionMatrix(test_data[, 10], model)
print(cm)
