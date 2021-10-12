#!/bin/bash

clustDir=$STORAGE/nhlp/projects/P50_2019/ClustSim

FN_MASK="$STORAGE/nhlp/masks/TT_N27_mask_2mm+tlrc"

3dClustSim -mask ${FN_MASK} -acf 0.4850 4.9699 10.5923 \
-LOTS -niml -both -prefix ${clustDir}/ClustSim_P50_2019_2mmMask