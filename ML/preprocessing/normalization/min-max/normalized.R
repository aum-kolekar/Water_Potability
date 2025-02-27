data = read.csv('median_impute.csv')

#creating function for normalization
normalize = function(x){
  return((x-min(x)) / (max(x)-min(x)))
}

norm_Data = as.data.frame(apply(data[2:10],2, normalize))

norm_Data$Potability = data$Potability
