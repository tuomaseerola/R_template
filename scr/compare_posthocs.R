# compare_posthocs.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/
library(emmeans)

# This is a follow-up from compare_means.R

## Which Tracks differ in sadness ratings? 
# Run posthoc analysis with Tukey's method for corrections.
m_tracks <- lmer(Rating ~ Track + (1|PID), data=tmp)
emm1<- emmeans(m_tracks, specs = pairwise ~ Track) # are emotions different between the tracks
print(knitr::kable(emm1$contrasts,digits = 3,caption = 'Post-hoc comparison of tracks for Sadness'))

# Does the Source make a difference?
m_source <- lmer(Rating ~ Source + (1|PID), data=tmp)
emm2<- emmeans(m_source, specs = pairwise ~ Source) # are emotions different between Experiments?
print(knitr::kable(pairs(emm2$emmeans),digits = 3,caption = 'Post-hoc comparison of Sources for Sadness'))
