#Used to plot the finding in the RAG between T1 and T2 words vs false font

library(dplyr)
library(ggplot2)

#Load in data
P50_2019 <- read.delim(dir("nhlp_data/projects/P50meeting_Dec2019/",
                               full.names=T, pattern="^P50_2019_20"),header=TRUE, sep="\t")
VISvFF_RAG <- read.delim(dir("nhlp_data/projects/P50meeting_Dec2019/graphics/scripts/",
                           full.names=T, pattern="^VISvFF_RAG"),header=FALSE, sep="\t")
VisFF_RAG <- read.delim(dir("nhlp_data/projects/P50meeting_Dec2019/graphics/scripts/",
                             full.names=T, pattern="^VisFF_RAG"),header=FALSE, sep="\t")


#Name the columns in VISvFF
colnames(VISvFF_RAG) <- c("mrrc_id","VISvFF")
colnames(VisFF_RAG) <- c("mrrc_id","VIS","FF")


#Create the dataframe
plot_T1T2_RAG <- VISvFF_RAG %>%
  left_join(VisFF_RAG, by = "mrrc_id") %>% 
  right_join(P50_2019, by = "mrrc_id") %>% 
  filter(record_id != 2,
         record_id != 109,
         record_id != 163) #removing cases where missing VISvFF map for either timepoint

#Test the differences
res <- t.test(plot_T1T2_RAG$VISvFF ~ plot_T1T2_RAG$mri_tp, paired=TRUE, 
              alternative="two.sided", na.rm = TRUE)
res

#Test the differences when the outliers are removed
plotRAG_OutRem <- plot_T1T2_RAG %>% 
  filter(VISvFF < 0.4,
         VISvFF > -0.3)
res <- t.test(plotRAG_OutRem$VISvFF ~ plotRAG_OutRem$mri_tp, paired=TRUE, 
              alternative="two.sided", na.rm = TRUE)
res

#Create the violin plot of Vis v FF
ggplot(plot_T1T2_RAG,aes(mri_tp,VISvFF)) + 
  #geom_point()+
  geom_violin(aes(fill=mri_tp))+
  stat_summary(fun.y=mean, geom="point", shape=18, color="white", size=5)+
  ylab("Activation for\n Words - False Font") +
  scale_fill_manual(name="",values=c("royalblue4","royalblue4","bisque4")) +
  #ggrepel::geom_text_repel(aes(label=ta)) +
  theme_bw(15)+
  theme(plot.title = element_text(hjust = 0.5),
        panel.spacing=unit(0,"lines"),
        strip.background=element_rect(color="black"),
        panel.border=element_rect(color="black"),
        axis.title.x = element_blank(),
        axis.text.x = element_text(color="black", size=40, face="bold"),
        axis.title.y = element_text(margin = margin(r=10), size=30, face="bold"),
        axis.text.y = element_text(size=20),
        #axis.text.x = element_text(angle=45, hjust=1),
        legend.position="none")
ggsave("plot_T1T2_RAG.pdf",useDingbats=FALSE)


####Separating into Vis only and FF only
#Test the differences in Words
mean(plot_T1T2_RAG$VIS[plot_T1T2_RAG$mri_tp=="T1"])
mean(plot_T1T2_RAG$VIS[plot_T1T2_RAG$mri_tp=="T2"])
res <- t.test(plot_T1T2_RAG$VIS ~ plot_T1T2_RAG$mri_tp, paired=TRUE, 
              alternative="two.sided", na.rm = TRUE)
res
#Test the differences in FF
mean(plot_T1T2_RAG$FF[plot_T1T2_RAG$mri_tp=="T1"])
mean(plot_T1T2_RAG$FF[plot_T1T2_RAG$mri_tp=="T2"])
res <- t.test(plot_T1T2_RAG$FF ~ plot_T1T2_RAG$mri_tp, paired=TRUE, 
              alternative="two.sided", na.rm = TRUE)
res

#Creating separate dataframes to join
VIS_RAG <- VisFF_RAG %>%
  left_join(P50_2019, by = "mrrc_id") %>% 
  select(-FF) %>% rename(Activation = VIS) %>% mutate(Act_type = "Words")
FF_RAG <- VisFF_RAG %>%
  left_join(P50_2019, by = "mrrc_id") %>% 
  select(-VIS) %>% rename(Activation = FF) %>% mutate(Act_type = "False Font")
VISvFF_RAG <- VISvFF_RAG %>%
  left_join(P50_2019, by = "mrrc_id") %>% 
  rename(Activation = VISvFF) %>% mutate(Act_type = "Words - False Font")
#Join dataframes
JoinDF <- VIS_RAG %>% 
  bind_rows(FF_RAG) %>% 
  bind_rows(VISvFF_RAG) %>% 
  mutate(Act_type = factor(Act_type, levels = c("Words","False Font", "Words - False Font")))

#Create the violin plot of Vis, FF, and Vis v FF
ggplot(JoinDF,aes(x=mri_tp, y=Activation, fill=Act_type)) + 
  #geom_point()+
  geom_violin(trim = FALSE)+
  scale_y_log10()+
  facet_wrap(~ Act_type)+
  stat_summary(fun.y=mean, geom="point", shape=18, color="white", size=5)+
  ylab("Activation in the\n Right Angular Gyrus") +
  scale_fill_manual(name="",values=c("royalblue4","firebrick4","darkorchid4")) +
  #ggrepel::geom_text_repel(aes(label=ta)) +
  theme_bw(15)+
  ylim(-0.5,0.5) +
  theme(plot.title = element_text(hjust = 0.5),
        panel.spacing=unit(0,"lines"),
        strip.background=element_rect(color="black"),
        panel.border=element_rect(color="black"),
        axis.title.x = element_blank(),
        axis.text.x = element_text(color="black", size=20, face="bold"),
        axis.title.y = element_text(margin = margin(r=10), size=30, face="bold"),
        axis.text.y = element_text(size=20),
        #axis.text.x = element_text(angle=45, hjust=1),
        legend.position="none")
ggsave("T1T2_RAG_byMod.pdf",useDingbats=FALSE)

