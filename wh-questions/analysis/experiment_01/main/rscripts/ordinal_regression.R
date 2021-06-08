library(MASS)
library(ordinal)
library(lme4)
library(ggplot2)
library(tidyverse)
library(broom)
library(textstem)
this.dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(this.dir)


# Setting up the data
test = read.csv("test_items_responses.csv")
corp = read.csv("test_items_corpus.csv")


test$numResponse = test$response
test$response <- ordered(as.factor(test$response))
test$Wh <- as.factor(test$Wh)
test$VerbLemma <- as.factor(test$VerbLemma)

test$Goal.included. = ifelse(test$Goal.included.=="","no",test$Goal.included.)

contrasts(test$Wh)
contrasts(test$VerbLemma)

# Tables

# 1. The basic distribution of responses
table(test$response)
prop.table(table(test$response))


# 2. Corpus: Wh by Matrix verb
table(corp[,c("Wh","VerbLemma")])
prop.table(table(corp[,c("Wh","VerbLemma")]),mar=c(1))

# 3. Wh overall
table(corp$Wh)

# 4. Embedding verb
table(corp$VerbLemma)

# 5. Goal included?
table(corp$Goal.included.)

#GGplots
View(test)

# How long did it take participants to do this experiment?
summary(test$time_in_minutes)

ggplot(test, aes(x=workerid,y=time_in_minutes)) +
  geom_point()


# Were there some items that were marked as stangeSentence (1) more than others?
test %>% group_by(tgrep_id) %>% summarize(mean=mean(strangeSentence))

agr_strange = test %>%
  group_by(tgrep_id) %>%
  summarize(MeanStrange = mean(strangeSentence), CI.Low = ci.low(strangeSentence), CI.High = ci.high(strangeSentence)) %>%
  mutate(YMin = MeanStrange - CI.Low, YMax = MeanStrange + CI.High)

agr_strange_new <- subset(agr_strange, MeanStrange > 0)

ggplot(agr_strange_new, aes(x=tgrep_id,y=MeanStrange)) +
  geom_point() +
  xlab("Item ID") +
  ylab("Mean marked 'Strange'") +
  theme(legend.position = "none",
      axis.text.x = element_blank())

ggsave(file="MeanStrange.pdf",width=5,height=4)

# Add MeanStrange to test
test_means <- left_join(test, agr_strange, by="tgrep_id")
View(test_means)
write.csv(test_means, "test_means.csv", row.names = FALSE)

test_means = read.csv("test_means.csv")

# Exclude means of StrangeSentence that exceed 0.4
agr_strange_exclude <- subset(test_means,MeanStrange >= 0.4)
View(agr_strange_exclude)

test_strange_exclude <- subset(test_means, MeanStrange < 0.4)
View(test_strange_exclude)

test_strange_exclude$numResponse = test_strange_exclude$response
test_strange_exclude$response <- ordered(as.factor(test_strange_exclude$response))
test_strange_exclude$Wh <- as.factor(test_strange_exclude$Wh)
test_strange_exclude$VerbLemma <- as.factor(test_strange_exclude$VerbLemma)

test_strange_exclude$Goal.included. = ifelse(test_strange_exclude$Goal.included.=="","no",test_strange_exclude$Goal.included.)

# Plot the means of responses by Wh

test_strange_exclude %>% group_by(Wh) %>% summarize(mean=mean(numResponse))

agr = test_strange_exclude %>%
  group_by(Wh) %>%
  summarize(MeanResponse = mean(numResponse), CI.Low = ci.low(numResponse), CI.High = ci.high(numResponse)) %>%
mutate(YMin = MeanResponse - CI.Low, YMax = MeanResponse + CI.High)

ggplot(agr, aes(x=Wh,y=MeanResponse)) +
  geom_bar(stat="identity",color="black",fill="gray60") +
  xlab("Wh-word") +
  ylab("Mean response") +
  # geom_jitter(data=lexdec,aes(y=rawRT),alpha=.2,color="lightblue") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25)

ggsave(file="Wh_bar_means.pdf",width=5,height=4)


# Plot the means of the embedding verbs

test %>% group_by(VerbLemma) %>% summarize(mean=mean(numResponse))

agr = test_strange_exclude %>%
  group_by(VerbLemma) %>%
  summarize(MeanLemma = mean(numResponse), CI.Low = ci.low(numResponse), CI.High = ci.high(numResponse)) %>%
  mutate(XMin = MeanLemma - CI.Low, XMax = MeanLemma + CI.High)

ggplot(agr, aes(x=MeanLemma,y=VerbLemma)) +
  geom_bar(stat="identity",color="black",fill="gray60") +
  xlab("Mean Response") +
  ylab("Embedding Verb") +
  # geom_jitter(data=lexdec,aes(y=rawRT),alpha=.2,color="lightblue") +
  geom_errorbar(aes(xmin=XMin,xmax=XMax),width=.25) 

ggsave(file="EmbVerb_bar_means.pdf",width=5,height=4)

# Plot the means of goal included or not

agr = test_strange_exclude %>%
  group_by(Goal.included.) %>%
  summarize(MeanGoal = mean(numResponse), CI.Low = ci.low(numResponse), CI.High = ci.high(numResponse)) %>%
  mutate(YMin = MeanGoal - CI.Low, YMax = MeanGoal + CI.High)

ggplot(agr, aes(x=Goal.included.,y=MeanGoal)) +
  geom_bar(stat="identity",color="black",fill="gray60") +
  xlab("Goal included in the prejacent") +
  ylab("Mean response") +
  # geom_jitter(data=lexdec,aes(y=rawRT),alpha=.2,color="lightblue") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25)

ggsave(file="Goal_included_means.pdf",width=5,height=4)

# Mixed effects model that looks at whether Wh element affected response

model_fit_Whmixed <- clmm(response~Wh +(1|workerid) +(1|tgrep_id), data = test, Hess=TRUE)
summary(model_fit_Whmixed)

m_Whmixed <- clmm(response~Wh +(1|workerid) +(1|tgrep_id), data = test_strange_exclude, Hess=TRUE)
summary(m_Whmixed)


# Mixed effects model looking at whether embedding verb significantly affects response

m_lemma_tgrepid <- clmm(response~VerbLemma +(1|workerid) +(1|tgrep_id), data = test, Hess=TRUE)
summary(m_lemma_tgrepid)

m_lemma_workerid_only <- clmm(response~VerbLemma +(1|workerid), data = test, Hess=TRUE)
summary(m_lemma_workerid_only)



test_strange_exclude = test_strange_exclude %>%
  mutate(VerbLemma = fct_relevel(VerbLemma, "tell"))


m_lemma_exclude <- clmm(response~VerbLemma +(1|workerid) +(1|tgrep_id), data = test_strange_exclude, Hess=TRUE)
summary(m_lemma_exclude)

#Subset by how, look at embedding verbs

test_only_how <- subset(test_strange_exclude, Wh == "how")



test_only_how = test_only_how %>%
  mutate(VerbLemma = fct_relevel(VerbLemma, "tell"))

contrasts(test_only_how$VerbLemma)

m_lemma_how <- clmm(response~VerbLemma +(1|workerid) +(1|tgrep_id), data = test_only_how, Hess=TRUE)
summary(m_lemma_how)

table(test_only_how$numResponse)

# 1   2   3   4   5   6   7 
# 303 235 113 266 149 278 409 

prop.table(table(test_only_how$numResponse))

# 1          2          3          4          5          6          7 
# 0.17284655 0.13405590 0.06446092 0.15173987 0.08499715 0.15858528 0.23331432 

#Subset by what, look at embedding verbs

test_only_what <- subset(test_strange_exclude, Wh == "what")

m_lemma_what <- clmm(response~VerbLemma +(1|workerid) +(1|tgrep_id), data = test_only_what, Hess=TRUE)
summary(m_lemma_what)

table(test_only_what$numResponse)
# 1   2   3   4   5   6   7 
# 54  33  28  89  39  88 173

prop.table(table(test_only_what$numResponse))
# 1          2          3          4          5          6          7 
# 0.10714286 0.06547619 0.05555556 0.17658730 0.07738095 0.17460317 0.34325397



#Subset by Goal not included, look at VerbLemma

test_only_goal <- subset(test_strange_exclude, Goal.included. == "no")

m_goal <- clmm(response~VerbLemma +(1|workerid) +(1|tgrep_id), data = test_only_goal, Hess=TRUE)
summary(m_goal)

test_only_goal %>% group_by(VerbLemma) %>% summarize(mean=mean(numResponse))



#Looking at whether the goal included predicts modal interpretation
test %>% group_by(Goal.included.) %>% summarize(mean=mean(numResponse))


m_prejacent <- clmm(response~Goal.included. +(1|workerid) +(1|tgrep_id), data = test_strange_exclude, Hess=TRUE)
summary(m_prejacent)


# Matrix Negation mean response
test %>% group_by(MatrixNegPresent) %>% summarize(mean=mean(numResponse))


#What are the log odds of getting ratings 1-7, given the presence of Matrix negation?
m_neg <- clmm(response~MatrixNegPresent +(1|workerid) +(1|tgrep_id), data = test_strange_exclude, Hess=TRUE)
summary(m_neg)















