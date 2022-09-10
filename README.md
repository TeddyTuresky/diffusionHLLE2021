# diffusionHLE2021

This repository houses code (or links to code) used for the following study:

##### *Ted K. Turesky\*, Joseph Sanfilippo\*, Jennifer Zuk, Banu Ahtam, Borjan Gagoski, Ally Lee, Kathryn Garrisi, Jade Dunstan, Clarisa Carruthers, Jolijn Vanderauwera, Xi Yu, Nadine Gaab (2021) Home language and literacy environment and its relationship with socioeconomic status and white matter structure in infancy, Brain Structure and Function (in press)*   \\\  \*these two authors contributed equally

We overhauled our methods during peer-review (we are genuinely grateful to the reviewers for suggesting the changes that they did). To maintain transparency, we include in this repository the code and other information related to versions of the manuscript before and after peer-review:

**After Peer-Review**  
The  scripts enclosed in this repository rely on the following packages:

.
├── Mrtrix3 | Mrtrix3Tissue
├── Anaconda3
├── ANTs2.3
├── FreeSurfer6.0
├── FSL6.0
├── cuda10.2
├── Matlab R2021a and the following packages (the following order of priority helps):
   ├── Vistasoft
   ├── SPM12
   ├── AFQ/babyAFQ

Dependences for optional calls
├── acpcdetect
├── netpbm

Adjustments to LD_LIBRARY_PATH
├── GCC libraries
├── Anaconda libraries

Additional prerequisite steps include ensuring the head axes are not oblique to FOV axes (or you can use the -c flag, which calls acpcdetect) and processing the anatomical image with Infant FreeSurfer.

An inventory of the code in this repository, and that used for diffusion image processing and statistical analyses is below:

    .
    ├── diffusion_pipeline_gen.sh                     <-- generates tract reconstructions from raw diffusion images using MRTrix, VistaSoft, and AFQ
        ├── vista_preprocessing.m                     <-- aligns diffusion and T1 images
        ├── mrtrix2babyAFQ.m                          <-- runs AFQ fiber segmentation
            ├── dti_end_tract.m                       <-- converts MRtrix .tck file to WholeBrainFG.mat for AFQ fiber segmentation
    ├── babyAFQ_vis_lafHLE.m                          <-- generates tract profiles with diffusion estimates and visualizations for figures
    ├── nonpar_boot_sp_corr.m                         <-- runs semipartial correlations (code fragments taken from https://github.com/yeatmanlab/AFQ) 
    ├── AFQ_MultiCompCorrectionSemiPartSpearman.m     <-- runs multiple comparison corrections for brain-behavior relations, adjusted from https://github.com/yeatmanlab/AFQ
    ├── hleMedsOpen.R                                 <-- tests for mediation


**Before Peer-Review**  
The following scripts were used to process the raw data and run statistical analyses:

    .
    ├── dtiConvPrepHLE.sh                               <-- conversion from dicom to nrrd using Slicer4 and DTI Prep (https://www.nitrc.org/projects/dtiprep/)
    ├── dtiGradientSelectGood.m                         <-- removes artifactual gradients identified by DTI Prep. New 4D diffusion volumes generated with dcm2niix
    ├── topEddyHLE.sh                                   <-- topup and eddy from FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy/UsersGuide)  
    ├── vista_preprocessingHLE.m                        <-- tensorfitting (https://vistalab.stanford.edu/)
    ├── DTI_AFQrun_mrdiff_SPM_HLE.m                     <-- fiber tracking (https://github.com/yeatmanlab/AFQ)
    ├── wholeBrainTractographyAllTractsSepHLE           <-- quality checks tract reconstructions. adapted from http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example
    ├── dti_corr_perm_100nodes_Spearman.m               <-- partial and semipartial correlations (code fragments taken from https://github.com/yeatmanlab/AFQ 
    ├── AFQ_MultiCompCorrectionPartSpearman.m           <-- multiple comparison corrections for StimQ, adjusted from https://github.com/yeatmanlab/AFQ   
    ├── AFQ_MultiCompCorrectionSemiPartSpearman.m       <-- multiple comparison corrections for maternal education, adjusted from https://github.com/yeatmanlab/AFQ
    ├── hleMedsO.R                                      <-- mediation testing 
    
    
Visualizations:

    .
    ├── vis_ind_tracts.m                                <-- generates figure 1 tracts
    ├── afq_vis_lslfHLE.m                               <-- generates figure 2 tracts

