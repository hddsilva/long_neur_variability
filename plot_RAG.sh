#!/bin/bash
#Used to plot the RAG deactivation from T1 to T2 for the P50 meeting in December 2019 


IDs=$STORAGE/nhlp/scripts/subjectIDs
subjects=$STORAGE/nhlp/processed
results=$STORAGE/nhlp/projects/P50_2019

#Created mask of the area in the RAG which shows a difference between T1 and T2. Did this interactively by choosing "Write" by the RAG cluster in the T2v1_WORDvFF map.


#Extract values within the targeted RAG area for participants with normal labeling
# for aSub in $(cat ${IDs}/P50_2019_ids_104.txt)
# do
# 	echo "Calculating Betas for ${aSub}"
# 	aSubDir=${subjects}/${aSub}/${aSub}.fastloc
# 	Coef=`3dinfo -label2index VisUnrel-FF_N#0_Coef ${aSubDir}/stats.${aSub}_REML+tlrc`
# 	Beta=$(3dROIstats -mask ${results}/masks/T2v1_RAG+tlrc ${aSubDir}/stats.${aSub}_REML+tlrc[${Coef}])
# 	echo $aSub $Beta >> ${results}/masks/VISvFF_RAG.txt		
# done

#Extract values within the targeted RAG area for participants with alternative labeling
# for aSub in $(cat ${IDs}/P50_2019_ids_104.txt)
# do
# 	echo "Calculating Betas for ${aSub}"
# 	aSubDir=${subjects}/${aSub}/${aSub}.fastloc
# 	Coef=`3dinfo -label2index vis_unrel_n-falsefont_n#0_Coef ${aSubDir}/stats.${aSub}_REML+tlrc`
# 	Beta=$(3dROIstats -mask ${results}/masks/T2v1_RAG+tlrc ${aSubDir}/stats.${aSub}_REML+tlrc[${Coef}])
# 	echo $aSub $Beta >> ${results}/masks/VISvFF_RAG.txt		
# done


##Within the RAG, words only and FF only to see if both rising or both falling, regardless of contrast between them
#Extract values within the targeted RAG area for participants with normal labeling
for aSub in $(cat ${IDs}/P50_2019_ids_104.txt)
do
	echo "Calculating Betas for ${aSub}"
	aSubDir=${subjects}/${aSub}/${aSub}.fastloc
	VisCoef=`3dinfo -label2index VIS_UNREL_no#0_Coef ${aSubDir}/stats.${aSub}_REML+tlrc`
	FFCoef=`3dinfo -label2index FALSE_FONT_no#0_Coef ${aSubDir}/stats.${aSub}_REML+tlrc`
	VisBeta=$(3dROIstats -mask ${results}/masks/T2v1_RAG+tlrc ${aSubDir}/stats.${aSub}_REML+tlrc[${VisCoef}])
	FFBeta=$(3dROIstats -mask ${results}/masks/T2v1_RAG+tlrc ${aSubDir}/stats.${aSub}_REML+tlrc[${FFCoef}])
	echo $aSub $VisBeta $FFBeta>> ${results}/masks/VisFF_RAG.txt		
done

