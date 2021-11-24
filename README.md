# diffusionHLE2021

This repository houses code (or links to code) used for the following study:

##### *Ted K. Turesky\*, Joseph Sanfilippo\*, Jennifer Zuk, Banu Ahtam, Borjan Gagoski, Ally Lee, Kathryn Garrisi, Jade Dunstan, Clarisa Carruthers, Jolijn Vanderauwera, Xi Yu, Nadine Gaab (2021) Home literacy environment mediates the relationship between socioeconomic status and white matter structure in infants, bioRxiv: doi.org/10.1101/2021.11.13.468500*   \*these two authors contributed equally


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

