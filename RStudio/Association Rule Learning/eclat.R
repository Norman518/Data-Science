library(arules)
dataset = read.csv("data/Market_Basket_Optimisation.csv", header = FALSE)
dataset = read.transactions("data/Market_Basket_Optimisation.csv",
                            sep = ',',
                            rm.duplicates = TRUE)
summary(dataset)
itemFrequencyPlot(dataset, topN = 10)

rules = eclat(data = dataset,
              parameter = list(support = 0.004, minlen = 2))

inspect(sort(rules, by = 'support')[1:10])
