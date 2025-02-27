#libraries ----
library("rpart.plot")
library("rpart")
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


#building model----
model = rpart(Potability ~ ., data = train_data, control = list(cp = 0.000001, minsplit = 10, minbucket = 10, xval = 7, maxdepth = 15))
rpart.plot(model)

#testing model----
set.seed(10)
prediction = predict(model, test_data[, -10], type = "class")

cm = confusionMatrix(test_data[, 10], prediction)
print(cm)
