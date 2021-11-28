# compare_contrasts.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

# What about just comparing the emotion we think this track should express,
# i.e. sadness to other tracks representing other emotions?
tmp <- dplyr::filter(df,Scale=='SADNESS')
m_tracks <- lmer(Rating ~ Track + (1|PID), data=tmp)
emm3 <- emmeans(m_tracks, 'Track') # are emotions different between tracks?
print(emm3)

# We can now do this by defining "contrasts" (sadness vs the other tracks)
sad_vs_others <- contrast(emm3, list(sadness_vs_others = c(6,-1,-1,-1,-1,-1,-1)))
print(sad_vs_others)
# the contrast defines which tracks are compared. The sum of contrast is 0
# (so if we compare one to six others).

# So, we can also pick other comparisons (here's one that looks 
# like non-significant from the figure we made earlier
anger_vs_surprise <- contrast(emm3, list(anger_surprise = c(0,0,0,-1,0,0,1)))
print(anger_vs_surprise)

# We could check this last contrast from our initial comparison of all
# emotions if we remove the adjustment for multiple corrections
emm4 <- emmeans(m_tracks, specs = pairwise ~ Track,adjust='none') # are emotions different between the tracks
emm4


