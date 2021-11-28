# figure2.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

library(ggplot2)
library(dplyr)

# An example figure showing contrast between the same track from the different Sources 1 & 2
tmp <- dplyr::filter(df,Scale=='SADNESS')

# Calculate means and 95% CIs
S <- tmp %>%
  group_by(Track,Source) %>%
  summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE),.groups = "drop") %>%
  mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 
S

# Plot with ggplot2
g2 <- ggplot(S,aes(x=Track,y=m,colour=Source,shape=Source))+
  geom_point(size=2,position = position_dodge(1))+
  geom_errorbar(aes(x=Track,ymin=LCI,ymax=UCI),width=0.5,position = position_dodge(1))+
  ylab('Mean ± 95% CI')+
  scale_y_continuous(limits = c(1,5))+
  scale_color_brewer(palette = 'Set1')+
  theme_bw()
print(g2)

