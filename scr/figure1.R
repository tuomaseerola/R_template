# figure1.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

library(ggplot2)
library(dplyr)

# An example figure showing contrast between the same track for all ratings of sadness.
tmp <- dplyr::filter(df,Scale=='SADNESS')

# Calculate means and 95% CIs
S <- tmp %>%
  group_by(Track) %>%
  summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE),.groups = "drop") %>%
  mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 

# Plot with ggplot2
g1<-ggplot(S,aes(x=Track,y=m))+
  geom_point()+
  geom_errorbar(aes(x=Track,ymin=LCI,ymax=UCI),width=0.5)+
  ylab('Mean ± 95% CI')+
  scale_y_continuous(limits = c(1,5))+
  theme_bw()
print(g1)
# If you want to save this to a file, you can:
# ggsave('sadness_ratings_across_tracks.pdf',g1,height=4,width = 6)
