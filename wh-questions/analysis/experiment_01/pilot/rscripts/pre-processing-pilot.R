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

corp = read.table("../../../../corpus/results/swbd.tab",sep="\t",header=T,quote="")
d = read.csv("../data/modals_in_whinfinitivals-merged.csv")

# rename item_id from corpus file
names(corp)[names(corp) == "Item_ID"] <- "tgrep_id"

# filter from the database the tgrep_ids from the raw data
corp_match = corp %>%
  filter(tgrep_id %in% d$tgrep_id)

# join dfs together
d <- left_join(d, corp_match, by="tgrep_id")

#exclude the example non-items and the bot check
test <- subset(d, tgrep_id != "example1"&tgrep_id != "example2"&tgrep_id != "bot_check")

write.csv(test, "testItems_with_responses.csv", row.names = FALSE)

ggplot(test, aes(x=response)) +
  geom_histogram(stat="count")

#separate by wh-element

how <- subset(test, Wh =="how")

ggplot(how, aes(x=response)) +
  geom_histogram(stat="count")

what <- subset(test, Wh == "what")

ggplot(what, aes(x=response)) +
  geom_histogram(stat="count")

strange <- subset(test, strangeSentence == 1)

ggplot(strange, aes(x=Wh)) +
  geom_histogram(stat="count")







