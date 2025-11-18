# visualise.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/

#### 1. histogram of responses by Track and Scale ----------------------------------
g1 <- ggplot(df, aes(x=Rating))+
  geom_histogram(fill='red',colour="black",bins = 5)+
  facet_wrap(Track~Scale)+
  #  scale_y_continuous(limits = c(0.8,5))+
  theme_bw()
print(g1)

#### 2. Violin plot of responses by Track, Source, and Scale ----------------------------------
g2 <- ggplot(df, aes(x=Track, y=Rating,fill=Track))+
  geom_violin(adjust=1)+
  facet_wrap(.~Scale,ncol = 1)+
#  scale_y_continuous(limits = c(0.8,5))+
  theme_bw()
print(g2)

#### 3. Bar and errors of responses by Track, Source, and Scale ----------------------------------

library(dplyr)
S1 <- df %>%
  group_by(Track,Source,Scale) %>%
  summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE),.groups = "drop") %>%
  mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 
#S1

# Graphics params
plsize <- 0.40 # errorbar line width
theme_fs <- function(fs=18){
  tt <- theme(axis.text = element_text(size=fs-1, colour=NULL)) + 
    theme(legend.text = element_text(size=fs, colour=NULL)) + 
    theme(legend.title = element_text(size=fs, colour=NULL)) + 
    theme(axis.title = element_text(size=fs, colour=NULL)) + 
    theme(legend.text = element_text(size=fs, colour=NULL))
  return <- tt
}
custom_theme_size <- theme_fs(14)
pd <- position_dodge(.6) # move them .05 to the left and right

g3<-ggplot(S1,aes(x=Track,y=m,shape=Source,group=Source,fill=Source))+
  geom_col(position = pd,size=1,width = .5)+
  geom_errorbar(S1, mapping=aes(x=Track, ymin=LCI, ymax=UCI), width=0.1, linewidth=plsize,position = pd,show.legend = FALSE,alpha=0.5)+
  facet_wrap(.~Scale,ncol = 1)+
  scale_fill_brewer(name='Experiment',palette = 'Set1')+
  scale_y_continuous(limits = c(0,5.0),breaks = seq(1,5),expand = c(0,0))+
  ylab('Mean Rating ± SE')+
  theme_bw()+
  custom_theme_size+
  theme(legend.position="top")
print(g3) 

#### 4. Difference between musicians and nonmusicians?  ----------------------------------

g4<-ggplot(df,aes(x=Gender,y=Rating,fill=Gender))+
  geom_col(alpha=0.5)+
  scale_fill_brewer(name='Gender',palette = 'Set1')+
  facet_wrap(.~Scale,ncol = 3)+
  theme_bw()+
  xlab('')
print(g4)

#### 5. Correlations between the emotions scales  ----------------------------------

U<-unique(df$Scale)
only_scales<-NULL
for (k in 1:length(U)) {
  tmp<-dplyr::filter(df,Scale==U[k])
  only_scales<-cbind(only_scales,tmp$Rating)
}
colnames(only_scales)<-U

g5 <- corPlot(only_scales,show.legend = FALSE,upper = FALSE,diag = FALSE,scale = FALSE,alpha = 0.75,cex = 0.9)

#### 6. Save to file?  ----------------------------------
# Some examples of how to save high-quality files

ggsave(filename = 'figures/histograms_by_scale_and_track.pdf', plot = g1, device = 'pdf', height = 7, width = 7)
ggsave(filename = 'figures/violin_by_scale_and_track.pdf',plot = g2,device = 'pdf',height = 7,width = 8)
ggsave(filename = 'figures/means_across_emotions_tracks_and_sources.pdf',device='pdf', plot = g3, width = 9, height = 9)
ggsave(filename = 'figures/means_across_musical_expertise.pdf',device='pdf', plot = g4, width = 7, height = 7)

rm(g1,g2,g3,g4,g5,k,only_scales,pd,plsize,S1,theme_fs,tmp,U,custom_theme_size)
