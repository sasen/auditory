library(PSYC201)
library(plyr)
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

fname="~/Dropbox/ucsd/projects/auditory/expts/DATA/B1040_3/fr_unit31.txt"
fr = read.table(fname,header=TRUE)
summary(fr)
m0=lmer(data=fr, play~1+(1|fam/ID),REML=FALSE)
mF=lmer(data=fr, play~fam*stat*dur+(1|fam/ID),REML=FALSE)
summary(m0)
summary(mF)
anova(m0,mF)
