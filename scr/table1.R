# table1.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

#### GLMM for each emotion scale comparing ratings for tracks and sources as fixed factors ------
tmp <- dplyr::filter(df,Scale=='SADNESS')

library(dplyr)
S <- tmp %>%
  group_by(Track,Source) %>%
  summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE),.groups = "drop") %>%
  mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 

# Create a nice table with kable and knitr
print(knitr::kable(S,digits = 2,caption='Ratings of Sadness across Tracks and Source.'))

rm(S,tmp)