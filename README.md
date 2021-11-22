# diffusionHLE2021

This repository houses code (or links to code) used for the following study:

##### *Ted K. Turesky, Joseph Sanfilippo, Jennifer Zuk, Banu Ahtam, Borjan Gagoski, Ally Lee, Kathryn Garrisi, Jade Dunstan, Clarisa Carruthers, Jolijn Vanderauwera, Xi Yu, Nadine Gaab (2021) Home literacy environment mediates the relationship between socioeconomic status and white matter structure in infants doi.org/10.1101/2021.11.13.468500*

All code was implemented on MacOSX and customized to the input for this particular study, but can be adapted be replacing pertinent paths, filenames, etc.

Raw images were first converted from dicom to nifti format, then inspected for artifacts. Analyses of remaining images (available in BIDS format here: insert link) relied predominantly on Mindboggle software (Klein et al., 2017), which was run in a Docker container according to the "Run one command" instructions here: https://mindboggle.info/. 

Following outputs (from subdirectories of mindboggle123_output > mindboggled > $sub-n) were analyzed:

    .
    ├── freesurfer_wmparc_labels_in_hybrid_graywhite.nii.gz      <-- volumes generated with ANTS and FreeSurfer using FreeSurfer labels 
    ├── hleMedsO.R                                         <-- surface-based measures      
    ├── hleMedsO.R                                         <-- surface-based measures      
    ├── AFQ_MultiCompCorrectionReg.m                       <-- surface-based measures      
    ├── hleMedsO.R                                         <-- surface-based measures      

As the surface-based measures we analyzed were originally output as 31 (cortical area) x 100 (surface-based measure)
