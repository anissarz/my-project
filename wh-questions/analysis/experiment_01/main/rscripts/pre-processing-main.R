library(ggplot2)
library(lme4)
library(lmerTest)
library(stringr)
library(textstem)
library(tidyverse)
theme_set(theme_bw())
this.dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(this.dir)
source("../../../helpers.R")


corp = read.csv("../../test_items_with_FullContext_3.csv")
View(corp)
d = read.csv("../data/modals_in_whinfinitivals_01-merged.csv")

# rename item_id from corpus file
names(corp)[names(corp) == "TGrepID"] <- "tgrep_id"
View(corp)

# filter from the database the tgrep_ids from the raw data
corp_match = corp %>%
  filter(tgrep_id %in% d$tgrep_id)

# join dfs together
d <- left_join(d, corp_match, by="tgrep_id")
View(d)

#exclude the example non-items and the bot check
test <- subset(d, tgrep_id != "example1"&tgrep_id != "example2"&tgrep_id != "bot_check")
View(test)


#look at the overall distribution of responses
ggplot(test, aes(x=response)) +
  geom_histogram(stat="count")

table(test$response)
prop.table(table(test$response))

#look at the overall distribution of responses by Wh-element
table(test[,c("Wh","response")])
prop.table(table(test[,c("Wh","response")]),mar=c(1))

#look at the distribution of sentences that were marked "Strange" by Wh-element
table(test[,c("Wh","strangeSentence")])
prop.table(table(test[,c("Wh","strangeSentence")]),mar=c(1))

#Lemmatize embedding verb
test$VerbLemma = lemmatize_words(test$MatrixPredVerb)
View(test)

corp$VerbLemma = lemmatize_words(corp$MatrixPredVerb)

#Add "sure" to MatrixPredVerb
test$MatrixPredVerb = ifelse(test$MatrixPredVerb=="","sure",test$MatrixPredVerb)

corp$MatrixPredVerb = ifelse(corp$MatrixPredVerb=="","sure",corp$MatrixPredVerb)

#Add "sure" to VerbLemma
test$VerbLemma = ifelse(test$VerbLemma=="","sure",test$VerbLemma)
View(test)

corp$VerbLemma = ifelse(corp$VerbLemma=="","sure",corp$VerbLemma)

#Add "no" to empty MatrixNegPresent
test$MatrixNegPresent = ifelse(test$MatrixNegPresent=="","no",test$MatrixNegPresent)
corp$MatrixNegPresent = ifelse(corp$MatrixNegPresent=="","no",corp$MatrixNegPresent)
View(test)

#Look at VerbLemma and response
table(test[,c("VerbLemma","response")])
prop.table(table(test[,c("VerbLemma","response")]),mar=c(1))


#Look at MatrixNegPresent and response
table(test[,c("MatrixNegPresent","response")])
prop.table(table(test[,c("MatrixNegPresent","response")]),mar=c(1))

#Only look at "know"
test_know <- subset(test, VerbLemma == "know")

#What does the distribution of "NegPresent" look like for "know"?
table(test_know[,c("MatrixNegPresent","response")])
prop.table(table(test_know[,c("MatrixNegPresent","response")]),mar=c(1))

#What does the distribution of "Wh" look like for "know"?
table(test_know[,c("Wh","response")])
prop.table(table(test_know[,c("Wh","response")]),mar=c(1))

#Eliminate sentences that were marked "Sounds strange"
test_no_strange <- subset(test, strangeSentence == 0)
View(test_no_strange)

table(test_no_strange[,c("Wh","response")])
prop.table(table(test_no_strange[,c("Wh","response")]),mar=c(1))

#Wh by Matrix verb
table(test[,c("Wh","VerbLemma")])
prop.table(table(test[,c("Wh","VerbLemma")]),mar=c(1))


#Look at aspects of the context: work in progress!!!
table(test[,c("Prejacent_specific_gen","response")])
prop.table(table(test[,c("Prejacent_specific_gen","Context_many_one", "strangeSentence")]),mar=c(1))


#save newly formatted corpus
write.csv(corp, "test_items_corpus.csv", row.names = FALSE)



#save newly formatted test items
write.csv(test, "test_items_responses.csv", row.names = FALSE)

