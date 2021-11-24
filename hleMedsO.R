# Tests for indirect effects using the mediation and lm.beta packages. 
# For questions: theodore_turesky@gse.harvard.edu

data <- read.csv("path-to-data-used-in-mediation/mediation-spreadsheet.csv") 


library(lm.beta)
library(mediation)


model.X <- lm(fa2932 ~ me + age + arhq, data)
model.M <- lm(stimq ~ me + age + arhq, data)
model.Y <- lm(fa2932 ~ stimq + me + age + arhq, data)


print(summary(model.X))
print(summary(model.M))
print(summary(model.Y))

model.X.beta <- lm.beta(model.X)
model.M.beta <- lm.beta(model.M)
model.Y.beta <- lm.beta(model.Y)
print(model.X.beta)
print(model.M.beta)
print(model.Y.beta)

results <- mediate(model.M, model.Y, treat='me', mediator='stimq', boot=TRUE, sims=10000)

print(summary(results))
