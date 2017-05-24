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

fname1="~/Dropbox/ucsd/projects/auditory/expts/analysis/figures/B1040_1ts/B1040_1ts_zfr_dataframe.txt"
fname2="~/Dropbox/ucsd/projects/auditory/expts/analysis/figures/B1040_2ts/B1040_2ts_zfr_dataframe.txt"
fname3="~/Dropbox/ucsd/projects/auditory/expts/analysis/figures/B1040_3ts/B1040_3ts_zfr_dataframe.txt"
fr1 = read.table(fname1,header=TRUE)
fr2 = read.table(fname2,header=TRUE)
fr3 = read.table(fname3,header=TRUE)
fr=rbind(fr1,fr2,fr3)
summary(fr)
#m0=lmer(data=fr, play~1+(1|fam/ID),REML=FALSE)
mF=lmer(data=fr, firingrate~family*stat+rep+(1|stimname)+(1|bird),REML=FALSE)
c#summary(m0)
#summary(mF)
#anova(m0,mF)
