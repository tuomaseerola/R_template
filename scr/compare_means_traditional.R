# compare_means.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

library(lme4)
library(lmerTest)
library(emmeans)
library(ggplot2)

#### LMM for each emotion scale comparing ratings for tracks and sources as fixed factors ------
tmp <- dplyr::filter(df,Scale=='SADNESS')
m1 <- lmer(Rating ~ as.numeric(Track) * as.numeric(Source) + as.numeric(MusicalExpertiseBinary) + as.numeric(Gender) + (1|PID), data=tmp)
s <- summary(m1,correlation=FALSE)

# if we want to see more information about the variable categories
m1_full <- lmer(Rating ~ Track * Source + MusicalExpertiseBinary + Gender + (1|PID), data=tmp)
summary(m1_full,correlation=FALSE)

# Let's just summarise the main effects and one interaction
print(knitr::kable(s$coefficients,digits = 3,caption = 'LMM results for Sadness.'))
