dataset = read.csv('data/Social_Network_Ads.csv')
dataset = dataset[3:5]

dataset$Purchased = factor(dataset$Purchased, levels = c(0, 1))

library(caTools)

set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = 0.75)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

training_set[-3] = scale(training_set[-3])
test_set[-3] = scale(test_set[-3])

library(e1071)

library(caret)
folds = createFolds(training_set$Purchased, k = 10)
cv = lapply(folds, function(x) {
  training_fold = training_set[-x,]
  test_fold = training_set[x,]
  classifier = svm(
    formula = Purchased ~ .,
    data = training_fold,
    type = 'C-classification',
    kernel = 'linear'
  )
  y_pred = predict(classifier, newdata = test_fold[-3])
  cm = table(test_fold[, 3], y_pred)
  accuracy = (cm[1, 1] + cm[2, 2]) / (cm[1, 1] + cm[2, 2] + cm[1, 2] + cm[2, 1])
  return (accuracy)
})
accuracy = mean(as.numeric(cv))
accuracy

classifier = train(form = Purchased ~ ., data= training_set, method = 'svmRadial')
classifier
classifier$bestTune
