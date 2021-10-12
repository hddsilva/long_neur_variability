#Used to create the dataframe for the longitudinal analyses used for the P50 meeting in Dec. 2019.
#Hailey 11/12/19

library(dplyr)

#Load in data
lookup_table <- read.delim(dir("nhlp_data/data_categories/lookup_table/",
                               full.names=T, pattern="^lookup_table_20"),header=TRUE, sep="\t")
questionnaire <- read.delim(dir("nhlp_data/data_categories/questionnaire/",
                                full.names=T, pattern="^questionnaire_20"),header=TRUE, sep="\t")
fastloc_driver_summary <- read.delim(dir("nhlp_data/data_categories/mri_data/additional_mri_data/driver_summaries/",
                                         full.names=T, pattern="^Fastloc_Driver_Summary_20"),header=TRUE, sep="\t")
long_mri <- read.delim(dir("nhlp_data/data_categories/mri_data/additional_mri_data/long_mri/",
                                         full.names=T, pattern="^long_mri_20"),header=TRUE, sep="\t")
mri_data <- read.delim(dir("nhlp_data/data_categories/mri_data/",
                           full.names=T, pattern="^mri_data_20"),header=TRUE, sep="\t")
long_mri_lag <- read.delim(dir("nhlp_data/data_categories/mri_data/additional_mri_data/long_mri/",
                               full.names=T, pattern="^long_mri_lag_20"),header=TRUE, sep="\t")


#Create the data frame
P50_2019 <- long_mri %>% 
  left_join(mri_data, by = "mrrc_id") %>% 
  left_join(long_mri_lag, by = "record_id") %>% 
  left_join(lookup_table, by = "record_id")  %>%   
  left_join(fastloc_driver_summary, by = c("mrrc_id" = "subject.ID"))  %>% 
  left_join(questionnaire, by = "record_id") %>%  
  rename(average_motion_per_TR = average.motion..per.TR., 
         censor_fraction = censor.fraction)  %>% 
  mutate(medicaid = case_when(pq19e == 1 ~ "Yes",
                              pq19e == 0 ~ "No"))  %>% 
  distinct() %>% 
  select(record_id,
         mrrc_id,
         mri_tp,
         age_mri,
         T1T2_lag,
         medicaid,
         average_motion_per_TR,
         censor_fraction) %>%
  filter(!is.na(T1T2_lag),
         mri_tp != "T3")

#Average and range of the interval between T1 and T2
min(P50_2019$T1T2_lag/30)
max(P50_2019$T1T2_lag/30)
mean(P50_2019$T1T2_lag/365)
sd(P50_2019$T1T2_lag/365)

#Write out dataframe
write.table(P50_2019, file=paste("nhlp_data/projects/P50meeting_Dec2019/P50_2019_",Sys.Date(),".txt",sep=""), sep="\t", row.names = FALSE)

#Write out mrrc_id list (T1 and T2 combined)
P50_2019_ids_104 <- select(P50_2019, mrrc_id) %>% arrange(mrrc_id)
write.table(P50_2019_ids_104, file=paste("nhlp_data/projects/P50meeting_Dec2019/P50_2019_ids_104_",Sys.Date(),".txt",sep=""), sep="\t", row.names = FALSE,
            col.names = FALSE, quote = FALSE)

#Write out T1 mrrc_id list
P50_2019_T1_ids <- filter(P50_2019,mri_tp=="T1") %>%  select(mrrc_id) %>% arrange(mrrc_id)
write.table(P50_2019_T1_ids, file=paste("nhlp_data/projects/P50meeting_Dec2019/P50_2019_T1ids_52_",Sys.Date(),".txt",sep=""), sep="\t", row.names = FALSE,
            col.names = FALSE, quote = FALSE)

#Write out T2 mrrc_id list
P50_2019_T2_ids <- filter(P50_2019,mri_tp=="T2") %>% select(mrrc_id) %>% arrange(mrrc_id)
write.table(P50_2019_T2_ids, file=paste("nhlp_data/projects/P50meeting_Dec2019/P50_2019_T2ids_52_",Sys.Date(),".txt",sep=""), sep="\t", row.names = FALSE,
            col.names = FALSE, quote = FALSE)


