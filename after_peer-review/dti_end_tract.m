function dti_end_tract(tck_file, mat_file)
% end of baby tractography

[pathstr, no_ext, ~] = fileparts(tck_file); 

pdb_file = fullfile(pathstr, no_ext, '.pdb');
fg = mrtrix_tck2pdb(tck_file, pdb_file);


dtiWriteFiberGroup(fg,mat_file);