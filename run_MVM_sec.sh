#!/bin/bash

#Used to run the MVM to compare activation at T1 and T2 for the Dec 2019 P50 meeting

parentDir="$STORAGE/nhlp"
projectPath="${parentDir}/projects/P50_2019"

FN_MASK=${parentDir}/masks/TT_N27_mask_2mm+tlrc

module load R/3.4.1-foss-2016b
module load Python/2.7.13-foss-2016b


cd ${projectPath}/MVM/

#Secondary model (age, T1/T2 lag, SES[medicaid] as covariates)
3dMVM -prefix ${projectPath}/MVM/Fastloc_longit_Sec+tlrc \
-jobs 20 \
-mask $FN_MASK \
-bsVars " T1_age+medicaid" \
-wsVars "mri_tp*CondLabel" \
-qVars T1_age \
-num_glt 24 \
-gltLabel 1 T1_words -gltCode 1 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel' \
-gltLabel 2 T1_words_low -gltCode 2 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel medicaid : 1*Yes' \
-gltLabel 3 T1_words_high -gltCode 3 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel medicaid : 1*No' \
-gltLabel 4 LOWvHIGH_T1words -gltCode 4 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel medicaid : 1*Yes -1*No' \
-gltLabel 5 T2_words -gltCode 5 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel' \
-gltLabel 6 T2_words_low -gltCode 6 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel medicaid : 1*Yes' \
-gltLabel 7 T2_words_high -gltCode 7 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel medicaid : 1*No' \
-gltLabel 8 LOWvHIGH_T2words -gltCode 8 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel medicaid : 1*Yes -1*No' \
-gltLabel 9 T2_v_1_words -gltCode 9 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel' \
-gltLabel 10 T2_v_1_words_low -gltCode 10 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel medicaid : 1*Yes' \
-gltLabel 11 T2_v_1_words_high -gltCode 11 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel medicaid : 1*No' \
-gltLabel 12 LOWvHIGH_T2v1_words -gltCode 12 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel medicaid : 1*Yes -1*No' \
-gltLabel 13 T1_words_v_FF -gltCode 13 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font' \
-gltLabel 14 T1_words_v_FF_low -gltCode 14 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes' \
-gltLabel 15 T1_words_v_FF_high -gltCode 15 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*No' \
-gltLabel 16 LOWvHIGH_T1_WORDSvFF -gltCode 16 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes -1*No' \
-gltLabel 17 T2_words_v_FF -gltCode 17 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font' \
-gltLabel 18 T2_words_v_FF_low -gltCode 18 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes' \
-gltLabel 19 T2_words_v_FF_high -gltCode 19 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*No' \
-gltLabel 20 LOWvHIGH_T2_WORDSvFF -gltCode 20 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes -1*No' \
-gltLabel 21 T2_v_1_words_v_FF -gltCode 21 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel -1*False_Font' \
-gltLabel 22 T2_v_1_words_v_FF_low -gltCode 22 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes' \
-gltLabel 23 T2_v_1_words_v_FF_high -gltCode 23 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*No' \
-gltLabel 24 LOWvHIGH_T2v1_words_v_FF -gltCode 24 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes -1*No' \
-num_glf 9 \
-glfLabel 1 MEtime_words -glfCode 1 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel' \
-glfLabel 2 T1_MEstimtype -glfCode 2 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font' \
-glfLabel 3 T1_MEstimtype_low -glfCode 3 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes' \
-glfLabel 4 T1_MEstimtype_high -glfCode 4 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*No' \
-glfLabel 5 LOWvHIGH_T1_MEstimtype -glfCode 5 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes -1*No' \
-glfLabel 6 T2_MEstimtype -glfCode 6 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font' \
-glfLabel 7 T2_MEstimtype_low -glfCode 7 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes' \
-glfLabel 8 T2_MEstimtype_high -glfCode 8 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*No' \
-glfLabel 9 LOWvHIGH_T2_MEstimtype -glfCode 9 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font medicaid : 1*Yes -1*No' \
-dataTable @MVM_DataTable_FastLoc.txt
