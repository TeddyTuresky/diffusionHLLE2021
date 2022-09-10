#!/bin/bash

# BabyBOLD Diffusion Pipeline



# trap keyboard interrupt (control-c)
trap control_c SIGINT

function Help {
    cat <<HELP
Usage:
`basename $0` -m MainDiffusionSequence -r ReversePhaseEncodingSequence -t FSL-SliceTable -o OutputDirectory -a InfantFreeSurferDirectory

Compulsory arguments:
     -m:  Directory containing raw dicoms for main diffusion sequence
     -r:  Directory containing raw dicoms with phase-encoding direction opposite main sequence
     -t:  FSL-formatted slice order table (please see -slspec flag here: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy/UsersGuide) 
     -o:  OutputDirectory: Full path to output directory
     -a:  Directory containing FreeSurfer style structure
Optional arguments:
     -c:  Perform ACPC alignment
     -f:  Method to generate FODs (msmt|ss3t) 
     -n:  Use SPM12 or ANTs for babyAFQ fiber tract segmentation (spm|ants)
--------------------------------------------------------------------------------------
script by T. Turesky, 2022
--------------------------------------------------------------------------------------

HELP
    exit 1
}


# Provide output for Help
if [[ "$1" == "-h" || $# -eq 0 ]]; then
    Help >&2
fi


# Read command line arguments
while getopts "h:m:r:t:o:a:f:n:c" OPT
  do
  case $OPT in
      h) #help
   Help
   exit 0
   ;;
      m)  # main sequence directory
   main=$OPTARG
   ;;
      r)  # reverse pe directory
   rev=$OPTARG
   ;;
      t)  # slice timing file for FSL eddy with slice-to-volume correction
   tim=$OPTARG
   ;;
      o)  # output directory
   out=$OPTARG
   ;;
      a)  # anatomy directory
   anat=$OPTARG
   ;;
      c)  # acpc align
   acpc=1
   ;;
      f)  # use (standard) msmt or ss3t
   fod=$OPTARG
   ;;
      n)  # use spm or ants normalization for tract segmentation
   nor=$OPTARG
   ;;
     \?) # getopts issues an error message
   echo "$USAGE" >&2
   exit 1
   ;;
  esac
done


# Ensure inputs exist
if [[ ! -d "${main}" ]]; then
    echo "Error: main sequence '${main}' does not exist."
    exit 1
fi

if [[ ! -d "${rev}" ]]; then
    echo "Error: reverse PE sequence '${rev}' does not exist."
    exit 1
fi

if [[ -d "${out}" ]]; then
     if [ "$(ls -A $out)" ]; then
	echo "Warning: chosen output directory not empty."
     fi
    # echo "Output directory '${out}' does not exist. Creating..." # below
fi

if [[ ! -f "${tim}" ]]; then
    echo "Error: FSL slice order table '${tim}', a prerequisite for eddy with slice-to-volume correction, does not exist."
    exit 1
fi

if [[ ! -d "${anat}" ]]; then
    echo "Error: directory containing anatomical images '${anat}' does not exist."
    exit 1
elif [[ ! -d "${anat}"/mri ]]; then
    echo "Error: directory '${anat}' exists, but does not contain FreeSurfer structure."
    exit 1
fi


# Set environmental variables - differs by choice of FOD tool
if [[ -v fod ]]; then

    case $fod in
        msmt)
        echo "You have opted for FOD generation with msmt."
        fd=1 # indicator for function below
        ;;

        ss3t)
        echo "You have opted for FOD generation with ss3t."
        fd=2 # indicator for function below
        ;;

        *)
        echo "Invalid specification for FOD generation. Defaulting to ss3t."
        fd=2 # indicator for function below        
	;;
    esac

else
    echo "FOD generation tool not specified. Defaulting to ss3t."
    fd=2 # indicator for function below
fi


# Set normalization tool for tract segmentation

if [[ -v nor ]]; then

    case $nor in
        spm)
        echo "You have opted for normalization with SPM."
        nr=0 # indicator for function below
        ;;

        ants)
        echo "You have opted for normalization with ANTs."
        nr=1 # indicator for function below
        ;;

        *)
        echo "Invalid normalization tool specified. Defaulting to SPM."
        nr=0
        ;;
    esac

else
    echo "Normalization tool not specified. Defaulting to SPM."
    nr=0
fi

# Load dependencies
# source /n/home_fasse/tturesky/dti_proc_msmt_10.2.sh


# Generate output directory structure
pdir=${out}/preproc
mkdir -p $pdir


# Pull anatomical data and FreeSurfer outputs
cp ${anat}/mprage.nii.gz ${pdir}/t1.nii.gz
cp ${anat}/mri/aseg.nii.gz ${out}
cp ${anat}/mri/brain.nii.gz ${out}


# ACPC-align anatomical data
if [ ${acpc} = 1 ]; then
    echo "Reorienting anatomical images to ACPC."
    gunzip ${pdir}/t1.nii.gz -f
    acpcdetect -i ${pdir}/t1.nii
    mri_convert -i ${out}/brain.nii.gz -o ${out}/brain_t1nn.nii.gz -rl ${pdir}/t1.nii    
    mri_convert -i ${out}/aseg.nii.gz -o ${out}/aseg_t1nn.nii.gz -rl ${pdir}/t1.nii -rt nearest
    flirt -in ${pdir}/t1.nii -ref ${pdir}/t1_RAS.nii -out ${pdir}/t1_acpc.nii.gz -applyxfm -init ${pdir}/t1_FSL.mat
    flirt -in ${out}/brain_t1nn.nii.gz -ref ${pdir}/t1_RAS.nii -out ${out}/brain_acpc.nii.gz -applyxfm -init ${pdir}/t1_FSL.mat
    flirt -in ${out}/aseg_t1nn.nii.gz -ref ${pdir}/t1_RAS.nii -out ${out}/aseg_acpc.nii.gz -applyxfm -init ${pdir}/t1_FSL.mat -interp nearestneighbour
    m_anat=\'t1_acpc\'
    brain=${out}/brain_acpc.nii.gz
    aseg=${out}/aseg_acpc.nii.gz
else
    m_anat=\'t1\'
    brain=${out}/brain.nii.gz
    aseg=${out}/aseg.nii.gz
fi


# Generate 5tt and gmwmi files for ACT
source $FREESURFER_HOME/sources.sh
5ttgen freesurfer $aseg ${out}/5tt.mif -nocrop -force
5tt2gmwmi ${out}/5tt.mif ${out}/5tt_gmwmi.mif -force


# Preprocess diffusion data
mrconvert ${main} ${pdir}/dwi.mif -force
mrconvert ${rev} ${pdir}/PA.mif -force
dwidenoise ${pdir}/dwi.mif ${pdir}/den_dwi.mif -force
mrconvert ${pdir}/den_dwi.mif ${pdir}/1_b0.mif -coord 3 0 -axes 0,1,2 -force
mrcat ${pdir}/1_b0.mif ${pdir}/PA.mif ${pdir}/1_b0_PA.mif -axis 3 -force
dwifslpreproc ${pdir}/den_dwi.mif ${pdir}/pre_den_dwi.mif -pe_dir AP -rpe_pair -se_epi ${pdir}/1_b0_PA.mif -align_seepi -eddy_options " --mporder=6 --slm=linear --ol_nstd=5" -eddy_slspec=${tim} -force
dwibiascorrect ants ${pdir}/pre_den_dwi.mif ${pdir}/N4_pre_den_dwi.mif -force
mrconvert ${pdir}/N4_pre_den_dwi.mif ${pdir}/N4_pre_den_dwi.nii.gz -export_grad_fsl ${pdir}/N4_pre_den_dwi.bvec ${pdir}/N4_pre_den_dwi.bval -force


# Align diffusion and T1 data and generate dt6 structure
echo "Aligning diffusion and T1 data and generating dt6 structure."
m_pdir=\'${pdir}\'
matlab -nodisplay -nojvm -nosplash -r "vista_preprocessing(${m_pdir}, 'N4_pre_den_dwi', ${m_anat}); exit;" > ${out}/log_vista.txt


# Generate tensors, run tractography, and segment tracts
echo "Generating FODs, running tractography, and segmenting fiber tracts."
pre=${out}/N4_pre_den_dwi_aligned_trilin_noMEC
mrconvert ${pre}.nii.gz ${pre}.mif -fslgrad ${pre}.bvecs ${pre}.bvals -force
dwi2mask ${pre}.mif ${pre}_mask.mif -force
dwi2response dhollander ${pre}.mif ${pre}_wm_resp.txt ${pre}_gm_resp.txt ${pre}_csf_resp.txt -fa 0.1 -lmax 0,8 -force

case $fod in
    msmt)
    dwi2fod msmt_csd ${pre}.mif ${pre}_wm_resp.txt ${pre}_wm_fod.mif ${pre}_csf_resp.txt ${pre}_csf_fod.mif -mask ${pre}_mask.mif -force
    ;;

    ss3t)
    ${SS3T}/ss3t_csd_beta1 ${pre}.mif ${pre}_wm_resp.txt ${pre}_wm_fod.mif ${pre}_csf_resp.txt ${pre}_csf_fod.mif -mask ${pre}_mask.mif -force
    ;;

    *)
    echo fod generation tool not specified
    ;;

esac

mtnormalise ${pre}_wm_fod.mif ${pre}_wm_fod_norm.mif ${pre}_csf_fod.mif ${pre}_csf_fod_norm.mif -mask  ${pre}_mask.mif -force
tckgen ${pre}_wm_fod_norm.mif -algorithm iFOD1 -info -backtrack -crop_at_gmwmi -seed_gmwmi ${out}/5tt_gmwmi.mif -act ${out}/5tt.mif -select 2000000 ${out}/dtitrilin/fibers/WholeBrainFG.tck -force

# Prepare and run babyAFQ
# gcc var needs to be exported above because matlab puts its own libraries ahead of shell environment libraries and gcc needs to be reset...
m_out=\'${out}\'
m_tck=\'${out}/dtitrilin/fibers/WholeBrainFG.tck\'
m_bzero=\'${out}/dtitrilin/bin/b0.nii.gz\'
m_brain=\'${brain}\'
m_aseg=\'${aseg}\'
m_fivett=\'${out}/5tt.mif\'
m_gcc=\'${GCC}:\'

matlab -nodesktop -nosplash -r "mrtrix2babyAFQ(${m_out}, ${m_tck}, ${m_bzero}, ${m_brain}, ${m_aseg}, ${m_fivett}, ${nr}, ${m_gcc}); exit;" > ${out}/log_babyAFQ.txt



