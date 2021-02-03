# compare_means.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

library(lme4)
library(lmerTest)
library(emmeans)
library(ggplot2)

emm_options(pbkrtest.limit = 3042) # Just allowing emmeans to run with large amount of data
emm_options(lmerTest.limit = 3042)

#### GLMM for each emotion scale comparing ratings for tracks and sources as fixed factors ------
tmp <- dplyr::filter(df,Scale=='SADNESS')
m1 <- lmer(Rating ~ as.numeric(Track) * as.numeric(Source) + as.numeric(MusicalExpertiseBinary) + as.numeric(Gender) + (1|PID), data=tmp)
s<-summary(m1,correlation=FALSE)

print(knitr::kable(s$coefficients,digits = 3,caption = 'LMM results for Sadness.'))

print(knitr::kable(round(confint(m1),2),caption = 'Confidence Intervals for the coefficients (Sadness)'))

## Which Tracks differ? (Drop background variables)
m_tracks <- lmer(Rating ~ Track + (1|PID), data=tmp)
emm1<- emmeans(m_tracks, specs = pairwise ~ Track) # are emotions different between the tracks
knitr::kable(contrast(emm1,adjust='bonferroni'),digits = 3,caption = 'Post-hoc comparison of tracks for Sadness')

m_source <- lmer(Rating ~ Source + (1|PID), data=tmp)
emm2<- emmeans(m_source, specs = pairwise ~ Source) # are emotions different between Experiments?
knitr::kable(pairs(emm2$emmeans),digits = 3,caption = 'Post-hoc comparison of Sources for Sadness')
