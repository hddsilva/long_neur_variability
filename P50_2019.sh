#!/bin/bash
idDir=$STORAGE/nhlp/scripts/subjectIDs
scriptDir=$STORAGE/nhlp/scripts/P50_2019
clustDir=$STORAGE/nhlp/projects/P50_2019/ClustSim

#Run the MVMs
#sbatch --mem-per-cpu=20GB --out $STORAGE/nhlp/scripts/P50_2019/slurm/run_MVM_prim_slurm.txt -J Prim $STORAGE/nhlp/scripts/P50_2019/run_MVM_prim.sh
#sbatch --mem-per-cpu=40GB -t 48:00:00 --out $STORAGE/nhlp/scripts/P50_2019/slurm/run_MVM_sec_slurm.txt -J Sec $STORAGE/nhlp/scripts/P50_2019/run_MVM_sec.sh


#Cluster Correction
##Calculate blur estimates
# for aSub in $(cat ${idDir}/P50_2019_ids_104.txt)
# do
# 	sbatch --out ${scriptDir}/slurm/blur_est/${aSub}_blur_est.txt -J ${aSub} ${scriptDir}/calc_blur_est.sh ${aSub}
# done

##Checked that the number of lines in blurerrts_acf_all.1D matched id numbers

##Step 5.2- Find the acf parameters to input into 3dClustSim
#1d_tool.py -show_mmms -infile ${clustDir}/blurerrts_acf_all.1D >> acf_parameters.txt

##Step 5.3- Run ClustSim
#sbatch --out ${scriptDir}/slurm/ClustSim.txt -J ClustSim ${scriptDir}/ClustSim.sh

#Add to ClustSim results to MVM
# for model in Prim Sec;
# do
# 	3drefit -atrstring AFNI_CLUSTSIM_NN1_1sided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN1_1sided.niml \
# 	  -atrstring AFNI_CLUSTSIM_MASK file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.mask \
# 	  -atrstring AFNI_CLUSTSIM_NN2_1sided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN2_1sided.niml \
# 	  -atrstring AFNI_CLUSTSIM_NN3_1sided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN3_1sided.niml \
# 	  -atrstring AFNI_CLUSTSIM_NN1_2sided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN1_2sided.niml \
# 	  -atrstring AFNI_CLUSTSIM_NN2_2sided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN2_2sided.niml \
# 	  -atrstring AFNI_CLUSTSIM_NN3_2sided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN3_2sided.niml \
# 	  -atrstring AFNI_CLUSTSIM_NN1_bisided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN1_bisided.niml \
# 	  -atrstring AFNI_CLUSTSIM_NN2_bisided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN2_bisided.niml \
# 	  -atrstring AFNI_CLUSTSIM_NN3_bisided file:$STORAGE/nhlp/projects/P50_2019/ClustSim/ClustSim_P50_2019_2mmMask.NN3_bisided.niml \
# 	$STORAGE/nhlp/projects/P50_2019/MVM/Fastloc_longit_${model}+tlrc
# done

#Created a plot for T2v1_VISvFF finding in RAG
sbatch --out ${scriptDir}/slurm/plot_RAG_2.txt -J RAG2 ${scriptDir}/plot_RAG.sh