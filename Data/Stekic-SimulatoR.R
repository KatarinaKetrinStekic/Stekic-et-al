library(tidyr) # for unite()
library(magrittr) # for pipe (%>%)
library(plyr)
library(truncnorm) # for generating truncated values with a normal distribution
library(reshape)
library(doBy)

setwd('F:/Experiments/Collaborations/Stekic et al/Repo/Data/Stimlists/')

# This takes all of the csv files in a given folder and collapses them into a single dataframe
# So in this case I've taken 40 subjects in each of the 6 conditions and collapsed them into one dataframe
# we are then going to put different types of fake data into the frame for sample analysis
library(data.table)
files <- dir("F:/Experiments/Collaborations/Stekic et al/Repo/Data/Stimlists/")
temp <- lapply(files, fread, sep = "\t")
AggregatedCSV<- rbindlist(temp)
AggregatedCSV$RespCorr <- 1
AggregatedCSV$RT <- 1000
AggregatedCSV <- as.data.frame(AggregatedCSV)

#######################################

TrainingResults <- subset(AggregatedCSV, TrialType == "Training")
TestingResults <- subset(AggregatedCSV, TrialType == "Testing")

# Lets generate some fake data! Wootwoot

TrainingResults <- summaryBy(RespCorr + RT ~ Id + Block + SubCondition + Condition, data= TrainingResults, Fun = mean)


# Random results, random reaction time
TrainingResults$RespCorr.1 <- rtruncnorm(n=nrow(TrainingResults), a=0, b= 1, mean= 0.75, sd=0.10)
TrainingResults$RT.1 <- rtruncnorm(nrow(TrainingResults), a= 200, b= 2000, mean = 500, sd= 100)

# Block effect - reaction time
TrainingResults$RespCorr.2 <- rtruncnorm(n=nrow(TrainingResults), a=0, b= 1, mean= 0.75, sd=0.10)
TrainingResults$RT.2 <- TrainingResults$RT.1 + (rtruncnorm(1,a=0, b=50, mean=20, sd=12)*TrainingResults$Block)

# Block effect- RespCorr
TrainingResults$RespCorr.3 <- TrainingResults$RespCorr.1 + (rtruncnorm(1, a= 0.0, b=0.03, mean=0.01, sd=0.005)) * TrainingResults$Block
TrainingResults$RespCorr.3 <- ifelse(TrainingResults$RespCorr.3 > 1.0, 1.0, TrainingResults$RespCorr.3)
TrainingResults$RT.3 <- rtruncnorm(nrow(TrainingResults), a= 200, b= 2000, mean = 500, sd= 100)

# Block effect - Both
TrainingResults$RespCorr.4 <- TrainingResults$RespCorr.1 + (rtruncnorm(1, a= 0.0, b=0.03, mean=0.01, sd=0.005)) * TrainingResults$Block
TrainingResults$RespCorr.4 <- ifelse(TrainingResults$RespCorr.3 > 1.0, 1.0, TrainingResults$RespCorr.3)
TrainingResults$RT.4 <- TrainingResults$RT.1 + (rtruncnorm(1,a=0, b=50, mean=20, sd=12)*TrainingResults$Block)

TrainingResults <- orderBy(~Condition + Block, data=TrainingResults)

### Effects by Condition
Cond1TrTrials <- subset(TrainingResults, Condition == '1')
Cond2TrTrials <- subset(TrainingResults, Condition == '2')
Cond3TrTrials <- subset(TrainingResults, Condition == '3A'|Condition =='3B')
Cond4TrTrials <- subset(TrainingResults, Condition == '4')
Cond5TrTrials <- subset(TrainingResults, Condition == '5')
Cond6TrTrials <- subset(TrainingResults, Condition == '6A'|Condition =='6B')
Cond7TrTrials <- subset(TrainingResults, Condition == '7')
Cond8TrTrials <- subset(TrainingResults, Condition == '8')
Cond9TrTrials <- subset(TrainingResults, Condition == '9')
Cond10TrTrials <- subset(TrainingResults, Condition == '10')

# Kat Predictions (Kondition, no Block)
Cond1TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond1TrTrials), a=0, b= 1, mean= 0.95, sd=0.10)
Cond2TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond2TrTrials), a=0, b= 1, mean= 0.70, sd=0.20)
Cond3TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond3TrTrials), a=0, b= 1, mean= 0.90, sd=0.10)
Cond4TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond4TrTrials), a=0, b= 1, mean= 0.85, sd=0.15)
Cond5TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond5TrTrials), a=0, b= 1, mean= 0.70, sd=0.20)
Cond6TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond6TrTrials), a=0, b= 1, mean= 0.80, sd=0.10)
Cond7TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond7TrTrials), a=0, b= 1, mean= 0.85, sd=0.10)
Cond8TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond8TrTrials), a=0, b= 1, mean= 0.75, sd=0.10)
Cond9TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond9TrTrials), a=0, b= 1, mean= 0.70, sd=0.10)
Cond10TrTrials$RespCorr.5 <- rtruncnorm(n=nrow(Cond10TrTrials), a=0, b= 1, mean= 0.65, sd=0.20)

Cond1TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond1TrTrials), a= 200, b= 2000, mean = 600, sd= 100)
Cond2TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond2TrTrials), a= 200, b= 2000, mean = 650, sd= 100)
Cond3TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond3TrTrials), a= 200, b= 2000, mean = 600, sd= 80)
Cond4TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond4TrTrials), a= 200, b= 2000, mean = 650, sd= 80)
Cond5TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond5TrTrials), a= 200, b= 2000, mean = 650, sd= 80)
Cond6TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond6TrTrials), a= 200, b= 2000, mean = 600, sd= 100)
Cond7TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond7TrTrials), a= 200, b= 2000, mean = 700, sd= 100)
Cond8TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond8TrTrials), a= 200, b= 2000, mean = 750, sd= 80)
Cond9TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond9TrTrials), a= 200, b= 2000, mean = 750, sd= 80)
Cond10TrTrials$RT.5 <- rtruncnorm(n=nrow(Cond10TrTrials), a= 200, b= 2000, mean = 800, sd= 110)
####################
Cond1TrTrials$RespCorr.6 <- rep(c(0.5,	0.6,	0.6,	0.7,	0.8,	0.8,	0.9,	0.9,	0.9), each =30)
Cond2TrTrials$RespCorr.6 <- rep(c(0.4,	0.4,	0.4,	0.5,	0.6,	0.6,	0.6,	0.8,	0.8), each =30)
Cond3TrTrials$RespCorr.6 <- rep(c(0.4,	0.5,	0.5,	0.4,	0.5,	0.6,	0.7,	0.8,	0.8), each =30)
Cond4TrTrials$RespCorr.6 <- rep(c(0.4,	0.4,	0.5,  0.5,	0.5,	0.6,	0.7,	0.8,	0.8), each =30)
Cond5TrTrials$RespCorr.6 <- rep(c(0.3,	0.3,	0.4,	0.5,	0.6,	0.6,	0.6,	0.7,	0.8), each =30)
Cond6TrTrials$RespCorr.6 <- rep(c(0.3,	0.3,	0.4,	0.4,	0.5,	0.6,	0.7,	0.7,	0.8), each =30)
Cond7TrTrials$RespCorr.6 <- rep(c(0.4,	0.4,	0.4,	0.5,	0.6,	0.6,	0.7,	0.7,	0.8), each =30)
Cond8TrTrials$RespCorr.6 <- rep(c(0.4,	0.4,	0.4,	0.5,	0.5,	0.6,	0.6,	0.7,	0.8), each =30)
Cond9TrTrials$RespCorr.6 <- rep(c(0.4,	0.5,	0.5,	0.6,	0.6,	0.7,	0.8,	0.8,	0.9), each =30)
Cond10TrTrials$RespCorr.6 <- rep(c(0.5,	0.5,	0.5,	0.6,	0.7,	0.7,	0.8,	0.8,	0.8), each =30)

Cond1TrTrials$RT.6 <- rep(c(800, 750, 700, 700, 700, 740, 700, 650, 600), each =30)
Cond2TrTrials$RT.6 <- rep(c(820, 750, 750, 750, 750, 720, 700, 700, 650 ), each =30)
Cond3TrTrials$RT.6 <- rep(c(830, 780, 750, 750, 720, 700, 730, 700, 650), each= 30)
Cond4TrTrials$RT.6 <- rep(c(830, 780, 740, 710, 730, 700, 700, 670, 650), each =30)
Cond5TrTrials$RT.6 <- rep(c(850, 790, 750, 720, 750, 720, 700, 650, 650), each =30)
Cond6TrTrials$RT.6 <- rep(c(830, 800, 760, 720, 750, 720, 720, 700, 670), each =30)
Cond7TrTrials$RT.6 <- rep(c(820, 800, 780, 750, 750, 730, 700, 700, 670), each =30)
Cond8TrTrials$RT.6 <- rep(c(830, 800, 770, 750, 750, 720, 700, 700, 660), each =30)
Cond9TrTrials$RT.6 <- rep(c(840, 800, 770, 750, 730, 750, 720, 700, 660), each =30)
Cond10TrTrials$RT.6 <- rep(c(820, 800, 750, 720, 700, 700, 700, 680, 650), each =30)

TrainingResults <- rbind(Cond1TrTrials, Cond2TrTrials, Cond3TrTrials, Cond4TrTrials, Cond5TrTrials,
                         Cond6TrTrials, Cond7TrTrials, Cond8TrTrials, Cond9TrTrials, Cond10TrTrials)

TrainingResults$RespCorr.6 <- rtruncnorm(n=nrow(TrainingResults), a=0, b= 1, 
                                          mean= TrainingResults$RespCorr.6 , sd=0.10)

TrainingResults$RT.6 <- rtruncnorm(n=nrow(TrainingResults), a=200, b= 2000, 
                                         mean= TrainingResults$RT.6 , sd=80)

TrainingResults$RespCorr.6 <- ifelse(TrainingResults$RespCorr.6 > 1.0, 1.0, TrainingResults$RespCorr.6)

## Add columns that recode condition into Congruency x ItemVsCategory
TrainingResults$Congruency <- mapvalues(TrainingResults$Condition,
                                        from= c(1,2,'3A','3B', 4,5,'6A', '6B', 7:10),
                                        to= c('Congruent', 'Incongruent', 'Conventional', 'Conventional',
                                              'Congruent', 'Incongruent', 'Conventional', 'Conventional',
                                              'Arbitrary', 'Arbitrary', 'Arbitrary', 'None'))

TrainingResults$CatVsItem <- mapvalues(TrainingResults$Condition,
                                       from= c(1,2,'3A','3B', 4,5,'6A', '6B', 7:10), 
                                       to= c(rep('Cat',4), rep('Item', 7), 'None'))

TrainingResults$Id <- paste(TrainingResults$Id, TrainingResults$Condition, TrainingResults$SubCondition, sep='-')

# Now we need to convert some columns to factors

TrainingResults$Id <- as.factor(TrainingResults$Id)
TrainingResults$SubCondition <- as.factor(TrainingResults$SubCondition)
TrainingResults$Condition <- as.factor(TrainingResults$Condition)
TrainingResults$Congruency <- as.factor(TrainingResults$Congruency)
TrainingResults$CatVsItem  <- as.factor(TrainingResults$CatVsItem)

############## Holy crap it's time for some statistics!
# So now we are going to run stats and produce graphs for our various FAKE data sets
library(lmerTest)
library(ggplot2)

######################################
TrRT.1 <- lmer(RT.1 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRT.1)

TrRC.1 <- lmer(RespCorr.1 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRC.1)

ggplot(data=TrainingResults, aes(x = Block , y = RT.1, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRT.1") +
  labs(x="Block", y="RT") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

ggplot(data=TrainingResults, aes(x = Block , y = RespCorr.1, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRX.1") +
  labs(x="Block", y="Proportion Correct") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

###################

TrRT.2 <- lmer(RT.2 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRT.2)

TrRC.2 <- lmer(RespCorr.2 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRC.2)

ggplot(data=TrainingResults, aes(x = Block , y = RT.2, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRT.2") +
  labs(x="Block", y="RT") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

ggplot(data=TrainingResults, aes(x = Block , y = RespCorr.2, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRX.2") +
  labs(x="Block", y="Proportion Correct") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))


#######################################
TrRT.3 <- lmer(RT.3 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRT.3)

TrRC.3 <- lmer(RespCorr.3 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRC.3)

ggplot(data=TrainingResults, aes(x = Block , y = RT.3, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRT.3") +
  labs(x="Block", y="RT") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

ggplot(data=TrainingResults, aes(x = Block , y = RespCorr.3, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRX.3") +
  labs(x="Block", y="Proportion Correct") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

#######################################
TrRT.4 <- lmer(RT.4 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRT.4)

TrRC.4 <- lmer(RespCorr.4 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRC.4)

ggplot(data=TrainingResults, aes(x = Block , y = RT.4, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRT.4") +
  labs(x="Block", y="RT") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

ggplot(data=TrainingResults, aes(x = Block , y = RespCorr.4, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRX.4") +
  labs(x="Block", y="Proportion Correct") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

#######################################
TrRT.5 <- lmer(RT.5 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRT.5)

TrRC.5 <- lmer(RespCorr.5 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRC.5)

ggplot(data=TrainingResults, aes(x = Block , y = RT.5, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRT.5") +
  labs(x="Block", y="RT") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

ggplot(data=TrainingResults, aes(x = Block , y = RespCorr.5, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRX.5") +
  labs(x="Block", y="Proportion Correct") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

#######################################
TrRT.6 <- lmer(RT.5 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRT.6)

TrRC.6 <- lmer(RespCorr.5 ~ Block * CatVsItem * Congruency + (1|Id), data=TrainingResults, REML= FALSE)
anova(TrRC.6)

ggplot(data=TrainingResults, aes(x = Block , y = RT.6, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRT.6") +
  labs(x="Block", y="RT") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))

ggplot(data=TrainingResults, aes(x = Block , y = RespCorr.6, group= Condition)) + 
  geom_smooth(aes(colour = Congruency, linetype = CatVsItem),size = 1,se = F, method = lm)+
  geom_point(aes(colour = Condition)) +
  ggtitle("TrRX.6") +
  labs(x="Block", y="Proportion Correct") +
  theme(axis.title.y = element_text(size=12,  color="#666666")) +
  theme(axis.text = element_text(size=8)) +
  theme(plot.title = element_text(size=16, face="bold", hjust=0, color="#666666"))
