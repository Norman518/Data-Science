dataset = read.csv('data/Position_Salaries.csv')
dataset = dataset[2:3]

library(e1071)
regressor = svm(formula = Salary ~ .,
                data = dataset,
                type = 'eps-regression')

y_pred = predict(regressor, data.frame(Level = 6.5))

library(ggplot2)
ggplot() +
  geom_point(aes(x = dataset$Level, y = dataset$Salary),
             color = 'red') +
  geom_line(aes(x = dataset$Level,
                y = predict(regressor, newdata = dataset)),
            color = 'blue') +
  ggtitle('True or False (SVR)') +
  xlab('Level') +
  ylab('Salary')
