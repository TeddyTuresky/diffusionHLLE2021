# diffusionHLE2021

This repository houses code (or links to code) used for the following study:

##### *Ted K. Turesky\*, Joseph Sanfilippo\*, Jennifer Zuk, Banu Ahtam, Borjan Gagoski, Ally Lee, Kathryn Garrisi, Jade Dunstan, Clarisa Carruthers, Jolijn Vanderauwera, Xi Yu, Nadine Gaab (2021) Home language and literacy environment and its relationship with socioeconomic status and white matter structure in infancy, Brain Structure and Function (in press)*   \\\  \*these two authors contributed equally

We overhauled our methods during peer-review (we are genuinely grateful to the reviewers for suggesting the changes that they did). To maintain transparency, we include in this repository the code and other information related to versions of the manuscript before and after peer-review:

**After Peer-Review**  
Diffusion Image Processing and Statistical Analyses:

    .
    ├── diffusion_pipeline_gen.sh                     <-- generates tract reconstructions from raw diffusion images using MRTrix, VistaSoft, and AFQ
        ├── vista_preprocessing.m                     <-- aligns diffusion and T1 images
        ├── mrtrix2babyAFQ.m                          <-- runs AFQ fiber segmentation
            ├── dti_end_tract.m                       <-- converts MRtrix *.tck file to WholeBrainFG.mat for AFQ fiber segmentation
    ├── babyAFQ_ComputeTractProperties.m*             <-- generates tract profiles with diffusion estimates and visualizations for figures
    ├── nonpar_boot_sp_corr.m                         <-- runs semipartial correlations (code fragments taken from https://github.com/yeatmanlab/AFQ) 
    ├── AFQ_MultiCompCorrectionSemiPartSpearman.m     <-- runs multiple comparison corrections for brain-behavior relations, adjusted from https://github.com/yeatmanlab/AFQ
    ├── hleMedsB.R                                    <-- tests for mediation


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

