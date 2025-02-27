library(pROC)

#DT----
probs <- predict(dt_tuned, newdata = test_data, type = "prob")
roc_dt <- roc(test_data$Potability, probs[, "1"])
# Plot ROC
plot(roc_dt, main = "ROC Curve - Decision Tree")

#KNN----
probs <- predict(tuned_model, test_data[, -10], type = "prob")
roc_knn <- roc(test_data$Potability, probs[, "1"])
# Plot ROC
plot(roc_knn, main = "ROC Curve - KNN")

#RF----
probs <- predict(rf_tuned, test_data[, -10], type = "prob")
roc_rf <- roc(test_data$Potability, probs[, "1"])
# Plot ROC
plot(roc_rf, main = "ROC Curve - Random Forest")

#SVM----
probs <- predict(best_model, test_data[, -1], decision.values = TRUE)
roc_svm <- roc(test_data$Potability, attr(probs, "decision.values"))
# Plot ROC
plot(roc_svm, main = "ROC Curve - SVM")

#XGB----
roc_xgb <- roc(testData$Potability, predictions)
# Plot ROC
plot(roc_xgb, main = "ROC Curve - XGBoost")

#ROC----
plot(roc_dt, col = "blue", main = "ROC Curves for All Models")
plot(roc_knn, col = "red", add = TRUE)
plot(roc_rf, col = "green", add = TRUE)
plot(roc_svm, col = "purple", add = TRUE)
plot(roc_xgb, col = "orange", add = TRUE)
legend("bottomright", legend = c("Decision Tree", "KNN", "Random Forest", "SVM", "XGBoost"), 
       col = c("blue", "red", "green", "purple", "orange"), lty = 1)
