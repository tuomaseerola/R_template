# interrater_reliability.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

#### 1. Response times --------------------------------------------------------------------
# let's see how fast some people were (this could be related to quality)

print(paste("Fastest response",round(min(df$Time,na.rm = T)/60,2),'mins')) # in minutes
print(paste("Slowest response",round(max(df$Time,na.rm = T)/60,2),'mins')) # in minutes
print(paste("Median response",round(median(df$Time,na.rm = T)/60,2),'mins')) # in minutes

fastest <- which(min(df$Time,na.rm = T)==df$Time)
as.character(df$PID[fastest[1]]) # PID

slowest <- which(max(df$Time, na.rm = T)==df$Time)
as.character(df$PID[slowest[1]]) # PID

# OK, let's keep them in for now.

#### 2. Distributions ---------------------------------------------------------------------

# Do we have participants who use the scale in weird ways?
g1<-ggplot(df,aes(x=Rating))+
  geom_histogram(bins = 5)+
#  facet_wrap(.~Scale)+
  facet_wrap(.~PID)+
  theme_bw()

print(g1)

# OK, none eliminated because of the scale use. 
# Let's see next whether we have some "random" responders

#### 3. Inter-rater reliability for all scales using Cronbach Alphas -------------------------

U<-unique(df$Scale)
S<-unique(df$PID)
alpha<-matrix(0,1,length(U))
for (k in 1:length(U)) {
#  print(as.character(U[k]))
  B <- dplyr::filter(df,Scale==U[k])
  TMP<-NULL
  for (i in 1:length(S)) {
    tmp<-dplyr::filter(B,PID==S[i])
    TMP<-cbind(TMP,as.numeric(tmp$Rating))
  }
  colnames(TMP)<-S
  a<-suppressMessages(suppressWarnings(psych::alpha(TMP,check.keys = FALSE,warnings = FALSE))) # t transpose
  alpha[k]<-a$total$raw_alpha
}

colnames(alpha)<-U
print(knitr::kable(alpha,digits=3,caption='Inter-reliability ratings (Cronbach alphas)'))

# We can explore the individuals who do not "conform" in more detail after this operation.
# Once the inconsistent participants have been identified, they can be discarded provided that you
# document and argue the elimination on a sound basis.

#### 4. Clean --------------------------------------------------------------------
rm(U,alpha,TMP,a,B,S,fastest,slowest,i,k,tmp,g1)
