#Used to generate the MVM datatable to check print at T1 and T2 and print vs falsefont
#at T1 and T2 in the NHLP sample. 

library(dplyr)

P50_2019 <- read.delim(dir("nhlp_data/projects/P50meeting_Dec2019/",
                                     full.names=T, pattern="^P50_2019_20"),header=TRUE, sep="\t")

T1_age <- P50_2019 %>% 
  filter(mri_tp == "T1") %>% 
  mutate(T1_age = age_mri) %>% 
  select(record_id, T1_age)

DataTable <- P50_2019 %>% 
  left_join(T1_age, by = "record_id") %>% 
  rename(Subj = record_id)
   
DataTable <- DataTable[rep(seq_len(nrow(DataTable)), 4), ]#repeats the data table multiple times (4 for number of stim types)
DataTable$CondLabel <- gl(4,104,416,labels = c("Vis_Unrel","False_Font","Aud_Unrel","Vocod"))
    #gl makes a factor (4 levels[for # stims], of each level[# participants], [# total rows/observations(multiplication result of first two)] )
DataTable$`InputFile\ \\` <- case_when(DataTable$CondLabel=="Vis_Unrel" ~ paste("/SAY/standard/Neonatology-726014-MYSM/nhlp/processed/",DataTable$mrrc_id,"/",DataTable$mrrc_id,".fastloc/stats.",DataTable$mrrc_id,"_REML+tlrc[VIS_UNREL_no#0_Coef]\ \\",sep=""),
                                          DataTable$CondLabel=="False_Font" ~ paste("/SAY/standard/Neonatology-726014-MYSM/nhlp/processed/",DataTable$mrrc_id,"/",DataTable$mrrc_id,".fastloc/stats.",DataTable$mrrc_id,"_REML+tlrc[FALSE_FONT_no#0_Coef]\ \\",sep=""),
                                          DataTable$CondLabel=="Aud_Unrel" ~ paste("/SAY/standard/Neonatology-726014-MYSM/nhlp/processed/",DataTable$mrrc_id,"/",DataTable$mrrc_id,".fastloc/stats.",DataTable$mrrc_id,"_REML+tlrc[AUD_UNREL_no#0_Coef]\ \\",sep=""),
                                          DataTable$CondLabel=="Vocod" ~ paste("/SAY/standard/Neonatology-726014-MYSM/nhlp/processed/",DataTable$mrrc_id,"/",DataTable$mrrc_id,".fastloc/stats.",DataTable$mrrc_id,"_REML+tlrc[VOCOD_no#0_Coef]\ \\",sep=""))
    #All of these were done for the conditions requiring no response


#Write out MVM data table
write.table(DataTable,"nhlp_data/projects/P50meeting_Dec2019/MVM_DataTable_FastLoc.txt",row.names = FALSE,col.names = TRUE,quote=FALSE)
