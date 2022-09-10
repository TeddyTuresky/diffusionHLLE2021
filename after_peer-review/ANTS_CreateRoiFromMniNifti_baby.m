function ANTS_CreateRoiFromMniNifti_baby(roiNifti, refNifti, invAffineXform, antsInvWarp, outfile)
% Transform rois aligned to UNC neonate template to native space template. 
% For questions, please contact theodore.turesky@childrens.harvard.edu.

if system('which antsApplyTransforms') ~= 0
    error('ANTs functions not installed or not in path');
end

% Create and execute the command to call ANTS
cmd = sprintf('antsApplyTransforms -d 3 -n NearestNeighbor -i %s -o %s -r %s -t %s -t %s', roiNifti, outfile, refNifti, invAffineXform, antsInvWarp);
system(cmd);
