dataset = read.csv('data/Churn_Modelling.csv')
dataset = dataset[4:14]

dataset$Geography = as.numeric(factor(
  dataset$Geography,
  levels = c('France', 'Spain', 'Germany'),
  labels = c(1, 2, 3)
))

dataset$Gender = as.numeric(factor(
  dataset$Gender,
  levels = c('Female', 'Male'),
  labels = c(1, 2)
))

library(caTools)
set.seed(123)
split = sample.split(dataset$Exited, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

library(xgboost)
classifier = xgboost(data = as.matrix(training_set[-11]),
                     label = training_set$Exited,
                     nrounds = 10)


training_set[-11] = scale(training_set[-11])
test_set[-11] = scale(test_set[-11])

library(caret)
folds = createFolds(training_set$Exited, k = 10)
cv = lapply(folds, function(x) {
  training_fold = training_set[-x,]
  test_fold = training_set[x,]
  classifier = xgboost(data = as.matrix(training_set[-11]),
                       label = training_set$Exited,
                       nrounds = 10)
  y_pred = predict(classifier, newdata = as.matrix(test_fold[-11]))
  y_pred = (y_pred >= 0.5)
  cm = table(test_fold[, 11], y_pred)
  accuracy = (cm[1, 1] + cm[2, 2]) / (cm[1, 1] + cm[2, 2] + cm[1, 2] + cm[2, 1])
  return (accuracy)
})
accuracy = mean(as.numeric(cv))
accuracy


library(h2o)
h2o.init(nthreads = -1)
classifier = h2o.deeplearning(y = 'Exited',
                              training_frame = as.h2o(training_set),
                              activation = 'Rectifier',
                              hidden = c(6, 6),
                              epochs = 100,
                              train_samples_per_iteration = -2)


prob_pred = h2o.predict(classifier, newdata = as.h2o(test_set[-11]))
y_pred = (prob_pred > 0.5)
y_pred = as.vector(y_pred)
cm = table(test_set[, 11], y_pred)
cm

h2o.shutdown()
