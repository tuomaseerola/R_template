# figure1.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

library(lme4)
library(emmeans)
library(ggplot2)

emm_options(pbkrtest.limit = 3042) # Just allowing emmeans to run with large amount of data
emm_options(lmerTest.limit = 3042)

# An example figure showing contrast between the same track from the different Sources 1 & 2
tmp <- dplyr::filter(df,Scale=='SADNESS')
m_both <- lmer(Rating ~ Source * Track + (1|PID), data=tmp)
emm3<- emmeans(m_both, specs = pairwise ~ Source | Track) # are emotions different between Experiments?
g2<-plot(emm3,CIs=TRUE,comparisons=FALSE,adjust='mvt',horizontal=TRUE,xlab='Contrast',aes(color = Track), int.adjust=TRUE)+
  theme_bw()+
  xlab('Mean Rating (±95% CI)')
print(g2)
