#library
library(glmnet)

#read data
data = read.csv("half.csv")
data = data[, -1]

#extract traget and feature
y <- as.matrix(data$Potability)
X <- as.matrix(data[, -which(names(data) == "Potability")])

#lasso
lasso_model <- glmnet(X, y, alpha = 1)

#plot lasso path
plot(lasso_model, xvar = "lambda", label = TRUE)

#cross validation for optimal lambda
cv_model <- cv.glmnet(X, y, alpha = 1)
plot(cv_model)

#finding the best lambda
best_lambda <- cv_model$lambda.min
cat("Optimal Lambda:", best_lambda, "\n")

#getting coefficent of selected model
selected_model <- glmnet(X, y, alpha = 1, lambda = best_lambda)
print(coef(selected_model))







