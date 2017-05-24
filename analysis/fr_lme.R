library(PSYC201)
library(dplyr)
library(ggplot2)
library(moments)
library(gridExtra) #install.packages("gridExtra")
library(reshape2)
library(pwr)
library(agricolae)  # HSD.test; call on an aov, give grouping factor
library(multcomp)
library(stringr)  # nonstandard
## library(nnet) multinom()
library(arm)  #se.ranef to extract standard errors of these.
library(lme4)
library(R.matlab)  #install.packages("R.matlab")

resultsDir = "~/Dropbox/ucsd/projects/auditory/expts/analysis/figures/"
fr1 = read.table(paste0(resultsDir,"B1040_1ts/B1040_1ts_zfr_dataframe.txt"),header=TRUE)
fr2 = read.table(paste0(resultsDir,"B1040_2ts/B1040_2ts_zfr_dataframe.txt"),header=TRUE)
fr3 = read.table(paste0(resultsDir,"B1040_3ts/B1040_3ts_zfr_dataframe.txt"),header=TRUE)
fr4 = read.table(paste0(resultsDir,"B953_2ts/B953_2ts_zfr_dataframe.txt"),header=TRUE)
fr5 = read.table(paste0(resultsDir,"B953_3ts/B953_3ts_zfr_dataframe.txt"),header=TRUE)
fr6 = read.table(paste0(resultsDir,"B992_1ts/B992_1ts_zfr_dataframe.txt"),header=TRUE)
fr=rbind(fr1,fr2,fr3,fr4,fr5,fr6)
rm(fr1,fr2,fr3,fr4,fr5,fr6)
fr$birdsite = as.factor(fr$birdsite)
fr$bird = as.factor(fr$bird)
fr$cluID = as.factor(fr$cluID)
str(fr)

m0=lmer(data=fr, firingrate~1+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
m1=lmer(data=fr, firingrate~family+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m0,m1)
m2=lmer(data=fr, firingrate~family+stat+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m1,m2)
# family:stat , or just family*stat
m3=lmer(data=fr, firingrate~family*stat+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m2,m3)

m4=lmer(data=fr, firingrate~family*stat+dur+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m3,m4)
m5=lmer(data=fr, firingrate~family*stat+dur+family:dur+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m4,m5)


#mF=lmer(data=fr, firingrate~family*stat+rep+(1|stimname)+(1|bird),REML=FALSE)
summary(m0)
#summary(mF)
#anova(m0,mF)
