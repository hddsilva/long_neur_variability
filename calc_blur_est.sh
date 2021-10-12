#!/bin/bash
#Calculate blur estimates

procDir=$STORAGE/nhlp/processed
clustDir=$STORAGE/nhlp/projects/P50_2019/ClustSim

aSub=$1

3dFWHMx -detrend -acf -mask ${procDir}/${aSub}/${aSub}.fastloc/full_mask.${aSub}+tlrc                            \
${procDir}/${aSub}/${aSub}.fastloc/stats.${aSub}_REML+tlrc >> ${clustDir}/blur_est/${aSub}.blur.err.acf.1D
1dcat ${clustDir}/blur_est/${aSub}.blur.err.acf.1D'[0..$]{1}' >> ${clustDir}/blurerrts_acf_all.1D
