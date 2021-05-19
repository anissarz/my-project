# title: "Analysis of Infinitival Relative Clauses"
library(ggplot2)
library(tidyverse)

this.dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(this.dir)

#reload after making changes
d = read.table("../results/swbd.tab",sep="\t",header=T,quote="")
View(d)

# take a look at counts for Trace
table(d$Trace)

#       adjunct neither  object 
# 73     433     286     300

#Look at the ones with no category

n = d %>%
  filter(Trace == "")
View(n)

#This has no category but it should be object
View(d[d["Item_ID"] == "33015:37"])



