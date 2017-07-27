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
fr$dur = with(fr,ifelse(dur=='s',0.8,ifelse(dur=='l',5,7)))
str(fr)

m0=lmer(data=fr, firingrate~1+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
m1=lmer(data=fr, firingrate~family+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m0,m1)
m2=lmer(data=fr, firingrate~family+stat+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m1,m2)
# family:stat , or just family*stat
m3=lmer(data=fr, firingrate~family*stat+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m2,m3)
rm(m0,m1,m2)

m4=lmer(data=fr, firingrate~family*stat+dur+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m3,m4)
m5=lmer(data=fr, firingrate~family*stat+dur+family:dur+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m4,m5)
m6=lmer(data=fr, firingrate~family*stat+dur+family:dur+stat:dur+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m5,m6)  # NOPPPPPPEEEEEE. also checked stat:dur vs m4, so stat:dur is useless

m6=lmer(data=fr, firingrate~family*stat+dur+family:dur+rep+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m5,m6)
rm(m3,m4,m5)
m7=lmer(data=fr, firingrate~family*stat+dur+family:dur+rep+family:rep+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m6,m7)
rm(m6)
m8=lmer(data=fr, firingrate~family*stat+dur+family:dur+rep+family:rep+stat:rep+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m7,m8)
rm(m7)
m9=lmer(data=fr, firingrate~family*stat*rep+dur+family:dur+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m8,m9)
rm(m8)
m10=lmer(data=fr, firingrate~family*stat*rep+dur+family:dur+dur:rep+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m9,m10)
rm(m9)
m11=lmer(data=fr, firingrate~family*stat*rep+dur+family:dur+dur:rep+family:dur:rep+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m10,m11)
m12=lmer(data=fr, firingrate~family*stat*rep+dur+family:dur+dur:rep+family:dur:rep+I(Z/1000)+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m11,m12)  # Nononononono
rm(m12)
m0a = lmer(data=fr, firingrate~I(Z/1000)+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m0,m0a)   # doublechecking, still no.
#gonna check for effect vs null model before adding more main effect factors, since m11 already so slow
m0b = lmer(data=fr, firingrate~I(ML/1000)+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m0,m0b)  # nope.
m0c = lmer(data=fr, firingrate~I(AP/1000)+(1|stimname)+(1|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m0,m0c)
rm(m0a,m0b,m0c)

m0i = lmer(data=fr, firingrate~1+(1|stimname)+(rep|bird)+(1|birdsite/cluID),REML=FALSE)
anova(m0,m0i)  # significant! but WHAT SHOULD I DO?
rm(m0i)
m0ii = lmer(data=fr, firingrate~1+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(m0,m0ii)  ### wowza, that is a lot of variance! also, the ranefs are nonzero now
rm(m0)
m1 = lmer(data=fr, firingrate~rep+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(m0ii,m1)  # NOPE rep is useless

m1 = lmer(data=fr, firingrate~family+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(m0ii,m1)
m2 = lmer(data=fr, firingrate~family+stat+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(m1,m2)  ### model fails to converge though. still significant improvement...
rm(m0ii,m1)
m3 = lmer(data=fr, firingrate~family*stat+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(m2,m3) ## but m3 converges, whatttt?
rm(m2)
m4 = lmer(data=fr, firingrate~family*stat+dur+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(m3,m4)  ### converge fail again
rm(m3)
m5 = lmer(data=fr, firingrate~family*stat+dur+family:dur+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(m4,m5)  ### converges  <---- CURRENT WINNER (though haven't tried to add bird)
m6 = lmer(data=fr, firingrate~family*stat+dur+family:dur+stat:dur+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(m5,m6)  # NOOOOPPEEEEE stat:dur is still useless
rm(m6)
mUno = lmer(data=fr, firingrate~stat+dur+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
mDos = lmer(data=fr, firingrate~stat*dur+(1|stimname)+(rep|birdsite/cluID),REML=FALSE)
anova(mUno,mDos)  # stat:dur loses!
rm(mUno,mDos)

#posthoc of diffs btw fam & stat  eg tukeyHSD <--- family, stat.... put asterisks over bars
##### by family
tuk <- glht(m5, mcp(family="Tukey"))  
#   covariate interactions found -- default contrast might be inappropriate
summary(tuk)
tuk.cld <- cld(tuk) # get groups
#In RET$pfunction("adjusted", ...) : Completion with error > abseps
old.par <- par(mai=c(1,1,1.25,1), no.readonly = TRUE) ### use sufficiently large upper margin
plot(tuk.cld) 
par(old.par)

##### by stat
tukstat <- glht(m5, mcp(stat="Tukey"))  # covariate interactions warning
summary(tukstat)
tukstat.cld <- cld(tukstat) # get groups
old.par <- par(mai=c(1,1,1.25,1), no.readonly = TRUE) ### use sufficiently large upper margin
plot(tukstat.cld, col=c("black", "red", "blue","green"))
par(old.par)


#fr%>%group_by(birdsite,stat,dur)%>%summarize(mean=mean(firingrate))
#filter(fr,cluID==0)%>% count(stat,cluID)
