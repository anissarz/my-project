library(MASS)
library(ggplot2)
library(tidyverse)
library(textstem)
this.dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(this.dir)


# Setting up the data
test = read.csv("../data/testItems_with_responses.csv")
summary(test)

test$response <- as.factor(test$response)
test$Wh <- as.factor(test$Wh)

# What are the log odds of getting ratings 1-7, given the Wh-element used: who, what, where, when, how
model_fit_Wh <- polr(response~Wh, data = test, Hess=TRUE)
summary(model_fit_Wh)

#Are these odds significant, i.e., what are the p-values?

summary_table <- coef(summary(model_fit_Wh))
pval <- pnorm(abs(summary_table[, "t value"]),lower.tail = FALSE)* 2
summary_table <- cbind(summary_table, "p value" = round(pval,3))
summary_table

#What are the log odds of getting ratings 1-7, given the embedding predicate?
model_fit_Matrix <- polr(response~MatrixPredVerb, data = test, Hess=TRUE)

#Are these odds significant?
summary_table <- coef(summary(model_fit_Matrix))
pval <- pnorm(abs(summary_table[, "t value"]),lower.tail = FALSE)* 2
summary_table <- cbind(summary_table, "p value" = round(pval,3))
summary_table

#What are the log odds of getting ratings 1-7, given the presence of Matrix negation?
model_fit_Neg <- polr(response~MatrixNegPresent, data = test, Hess=TRUE)

#Are these odds significant?
summary_table <- coef(summary(model_fit_Neg))
pval <- pnorm(abs(summary_table[, "t value"]),lower.tail = FALSE)* 2
summary_table <- cbind(summary_table, "p value" = round(pval,3))
summary_table






