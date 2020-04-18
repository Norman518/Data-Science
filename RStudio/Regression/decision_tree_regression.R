dataset = read.csv('data/Position_Salaries.csv')
dataset = dataset[2:3]

library(rpart)
regressor = rpart(formula = Salary ~ .,
                  data = dataset,
                  control = rpart.control(minsplit = 1))

y_pred = predict(regressor, data.frame(Level = 6.5))

library(ggplot2)
x_grid = seq(min(dataset$Level), max(dataset$Level), 0.1)
ggplot() +
  geom_point(aes(x = dataset$Level, y = dataset$Salary),
             color = 'red') +
  geom_line(aes(x = x_grid,
                y = predict(regressor, newdata = data.frame(Level = x_grid))),
            color = 'blue') +
  ggtitle('True or False (Decision Tree Regression)') +
  xlab('Level') +
  ylab('Salary')
