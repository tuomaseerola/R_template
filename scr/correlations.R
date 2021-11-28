# correlations.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

library(tidyr)
# go back to wide format for scales
df_wider <- pivot_wider(df,names_from = Scale,values_from = Rating)
head(df_wider)

# Calculate correlations between some concepts
cor(df_wider$SADNESS,df_wider$CALMNESS)
cor.test(df_wider$SADNESS,df_wider$CALMNESS)

# Correlation matrix
cm <- cor(df_wider[,8:14])
print(round(cm,2)) # table
# figure
#corPlot(cm,show.legend = FALSE,upper = FALSE,diag = FALSE,scale = FALSE,alpha = 0.75)

## Regression. 
# Can we predict the ratings of anger from the other scales and let's throw age there as well.

model1 <- lm(ANGER ~ SADNESS + CALMNESS + JOY + FEAR + POWER + SURPRISE + Age, data=df_wider)
model1
summary(model1)

# The above is not the most meaningful analysis to carry out, 
# but it would suggest that you can
# predict about 44% of ratings of ANGER scale from the other scales.
# Learning how to interpret the model coefficients (beta coefficients) and 
# reading which predictors contribute is what you need to be able to in regression.
# For now, this complements the analysis but does not really answer any
# meaningful research question. 

