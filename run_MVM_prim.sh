#!/bin/bash

#Used to run the MVM to compare activation at T1 and T2 for the Dec 2019 P50 meeting

parentDir="$STORAGE/nhlp"
projectPath="${parentDir}/projects/P50_2019"

FN_MASK=${parentDir}/masks/TT_N27_mask_2mm+tlrc

module load R/3.4.1-foss-2016b
module load Python/2.7.13-foss-2016b


cd ${projectPath}/MVM/

#Primary model (just age and T1/T2 lag as covariates)
3dMVM -prefix ${projectPath}/MVM/Fastloc_longit_Prim+tlrc \
-jobs 20 \
-mask $FN_MASK \
-bsVars T1_age \
-wsVars "mri_tp*CondLabel" \
-qVars T1_age \
-num_glt 6 \
-gltLabel 1 T1_words -gltCode 1 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel' \
-gltLabel 2 T2_words -gltCode 2 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel' \
-gltLabel 3 T2_v_1_words -gltCode 3 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel' \
-gltLabel 4 T1_words_v_FF -gltCode 4 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font' \
-gltLabel 5 T2_words_v_FF -gltCode 5 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font' \
-gltLabel 6 T2_v_1_words_v_FF -gltCode 6 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel -1*False_Font' \
-num_glf 3 \
-glfLabel 1 MEtime_words -glfCode 1 'mri_tp : 1*T2 -1*T1 CondLabel : 1*Vis_Unrel' \
-glfLabel 2 T1_MEstimtype -glfCode 2 'mri_tp : 1*T1 CondLabel : 1*Vis_Unrel -1*False_Font' \
-glfLabel 3 T2_MEstimtype -glfCode 3 'mri_tp : 1*T2 CondLabel : 1*Vis_Unrel -1*False_Font' \
-dataTable @MVM_DataTable_FastLoc.txt




