#!/bin/bash

# script for converting dicoms to nrrd for subsequent artifact detection in dtiPrep. Runs on Darwin.
# for questions, please contact theodore_turesky@gse.harvard.edu


# Put paths to diffusion dicoms in p

p=(

)

for ((i=0;i<${#p[@]};i++)); do

DWIConvert -i ${p[i]} -o ${p[i]}/dtiRaw.nrrd --useBMatrixGradientDirections

DTIPrep -c -p ${p[i]}/dtiRaw.xml --numberOfThreads 8 -w ${p[i]}/dtiRaw.nrrd  #removed default flag

LANG=C sed -i '' 's/unsigned //g' ${p[i]}/dtiRaw_QCed.nrrd; 

DWIConvert --inputVolume ${p[i]}/dtiRaw_QCed.nrrd --outputVolume ${p[i]}/prepped.nii.gz --outputBVectors ${p[i]}/prepped.bvec --outputBValues ${p[i]}/prepped.bval --conversionMode NrrdToFSL

done

echo done with convert and dtiprep
