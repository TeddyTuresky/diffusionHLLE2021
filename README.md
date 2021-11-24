# diffusionHLE2021

This repository houses code (or links to code) used for the following study:

##### *Ted K. Turesky, Joseph Sanfilippo, Jennifer Zuk, Banu Ahtam, Borjan Gagoski, Ally Lee, Kathryn Garrisi, Jade Dunstan, Clarisa Carruthers, Jolijn Vanderauwera, Xi Yu, Nadine Gaab (2021) Home literacy environment mediates the relationship between socioeconomic status and white matter structure in infants doi.org/10.1101/2021.11.13.468500*

All code customized to the input for this particular study, but can be adapted by replacing pertinent paths, filenames, etc.

The following scripts were used to process the raw data and run statistical analyses:

    .
    ├── dtiConvPrepHLE.sh          <-- conversion from dicom to nrrd using Slicer4 (https://www.slicer.org/) and DTI Prep (https://www.nitrc.org/projects/dtiprep/)
    ├── topEddyHLE.sh                                       <-- topup and eddy from FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy/UsersGuide)  
    ├── vista_preprocessingHLE.m                                         <-- tensorfitting (https://vistalab.stanford.edu/)
    ├── DTI_AFQrun_mrdiff_SPM_HLE.m                                        <-- fiber tracking (https://github.com/yeatmanlab/AFQ)
    ├── dti_corr_perm_100nodes_Spearman.m                    <-- partial and semipartial correlations (code fragments taken from https://github.com/yeatmanlab/AFQ 
    ├── AFQ_MultiCompCorrectionPartSpearman.m                <-- multiple comparison corrections for StimQ, adjusted from https://github.com/yeatmanlab/AFQ   
    ├── AFQ_MultiCompCorrectionSemiPartSpearman.m       <-- multiple comparison corrections for maternal education, adjusted from https://github.com/yeatmanlab/AFQ
    ├── hleMedsO.R                                         <-- mediation testing 
    
visualizations

    .
    ├── afq_vis_lslf2                                         <-- mediation testing 
    ├── hleMedsO.R                                         <-- mediation testing 



As the surface-based measures we analyzed were originally output as 31 (cortical area) x 100 (surface-based measure)
