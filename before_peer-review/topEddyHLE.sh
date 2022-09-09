#!/bin/bash

# This script is for FSL preprocessing. For questions, please contact theodore_turesky@gse.harvard.edu or see: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy/UsersGuide


p=(

/path2subFolders

);

acq=/path2/acqparams.txt
#ind=/path2/index.txt

for i in ${p[@]}; do

cd $i

s=(`echo $i | cut -d / -f 7`)

echo running $i
{

v=(`wc -w ${s}_dtiQCed.bval | awk '{ print $1 }'`); indx=""; for ((k=1; k<=$v; k+=1)); do indx="$indx 1"; done; echo $indx > index.txt
#ind=(`echo *index.txt`)

fslroi ${s}_dtiQCed.nii.gz AP_b0 0 1

fslmerge -t AP_AP_PA_b0 AP_b0.nii ${s}_regDTI_AP.nii.gz ${s}_regDTI_PA.nii.gz

topup --imain=AP_AP_PA_b0 --datain=${acq} --config=b02b0.cnf --out=my_topup_results --iout=my_hifi_b0 --fout=my_field

#topup only
#applytopup --imain=${s}_dtiQCed.nii.gz --inindex=1 --datain=${acq} --topup=my_topup_results --method=jac --out=my_hifi_images

#eddy option
fslmaths my_hifi_b0 -Tmean my_hifi_b0

bet my_hifi_b0 my_hifi_b0_brain -m

eddy --imain=${s}_dtiQCed.nii.gz --mask=my_hifi_b0_brain_mask --acqp=${acq} --index=index.txt --bvecs=${s}_dtiQCed.bvec --bvals=${s}_dtiQCed.bval --topup=my_topup_results --niter=8 --fwhm=10,8,4,2,0,0,0,0 --repol --out=eddy_corrected_data

} || {

echo $i did not run properly

}


done


echo done Topping Up and Eddying

