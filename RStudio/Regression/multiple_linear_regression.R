dataset = read.csv('data/50_startups.csv')

dataset$State = factor(
  dataset$State,
  levels = c('New York', 'California', 'Florida'),
  labels = c(1, 2, 3)
)

library(caTools)
set.seed(123)
split = sample.split(dataset$Profit, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
testing_set = subset(dataset, split == FALSE)

regressor = lm(formula = Profit ~ .,
               data = training_set)

summary(regressor)

y_pred = predict(regressor, newdata = testing_set)
y_pred

regressor = lm(formula = Profit ~ R.D.Spend + Administration + Marketing.Spend,
               data = dataset)

summary(regressor)

regressor = lm(formula = Profit ~ R.D.Spend + Marketing.Spend,
               data = dataset)

summary(regressor)

regressor = lm(formula = Profit ~ R.D.Spend + Marketing.Spend,
               data = dataset)

summary(regressor)

regressor = lm(formula = Profit ~ R.D.Spend,
               data = dataset)

summary(regressor)


backwardElimination <- 
  function(x, sl) {
  numVars = length(x)
  for (i in c(1:numVars)){
    regressor = lm(formula = Profit ~ ., data = x)
    maxVar = max(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"])
    if (maxVar > sl){
      j = which(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"] == maxVar)
      x = x[, -j]
    }
    numVars = numVars - 1
  }
  return(summary(regressor))
}

SL = 0.05
dataset = dataset[, c(1,2,3,4,5)]
summary = backwardElimination(training_set, SL)
summary