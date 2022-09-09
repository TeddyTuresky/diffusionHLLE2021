# Tests for indirect effects using the mediation and lm.beta packages. 
# For questions: theodore_turesky@gse.harvard.edu

library(lm.beta)
library(mediation)

data <- read.csv("path-to-data-used-in-mediation/mediation-spreadsheet.csv")


med1 <- "stimq"  # mediator
ind1 <- "me"     # independent variable
cov <- paste("age", "+", "sex", "+", "arhq") # list of covariates
c_in <- 1        # first brain estimate column
c_out <- 2      # last brain estimate column



varlist2 <- names(data)[c_in:c_out] 
esta <- matrix(ncol=1, nrow=(c_out-c_in+1)) 
ci1a <- matrix(ncol=1, nrow=(c_out-c_in+1))
ci2a <- matrix(ncol=1, nrow=(c_out-c_in+1))
pa <- matrix(ncol=1, nrow=(c_out-c_in+1))
estp <- matrix(ncol=1, nrow=(c_out-c_in+1)) 
ci1p <- matrix(ncol=1, nrow=(c_out-c_in+1))
ci2p <- matrix(ncol=1, nrow=(c_out-c_in+1))
pp <- matrix(ncol=1, nrow=(c_out-c_in+1))


for (i in c(1:(c_out-c_in+1)))
{
  

FormulaM <- paste(med1, "~", ind1, "+", cov, sep =' ') # model relating independent variable to potential mediator  "+", cov, 
print(FormulaM)
FormulaY <- paste(varlist2[[i]], "~", med1, "+", ind1, "+", cov, sep =' ') # model relating potential mediator to dependent variable, controlling for independent variable 
print(FormulaY)

model.M <- lm(FormulaM, data)
model.Y <- lm(FormulaY, data)

print(summary(model.M))
print(summary(model.Y))

model.M.beta <- lm.beta(model.M)
model.Y.beta <- lm.beta(model.Y)
print(model.M.beta)
print(model.Y.beta)

results <- mediate(model.M, model.Y, treat=ind1, mediator=med1, conf.level = 0.95, boot=TRUE, sims=10000)

# consolidate results
esta[i,] <- results$d0
ci1a[i,] <- results$d0.ci[[1]]
ci2a[i,] <- results$d0.ci[[2]]
pa[i,] <- results$d0.p

estp[i,] <- results$n0
ci1p[i,] <- results$n0.ci[[1]]
ci2p[i,] <- results$n0.ci[[2]]
pp[i,] <- results$n0.p

print(summary(results))

}