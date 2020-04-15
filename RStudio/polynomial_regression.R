dataset = read.csv('data/Position_Salaries.csv')
dataset = dataset[2:3]

lin_reg = lm(formula = Salary ~ .,
               data = dataset)

dataset$Level2 = dataset$Level^2
dataset$Level3 = dataset$Level^3
poly_reg = lm(formula = Salary ~ .,
              data = dataset)

