function ANTS_normalize_baby(anatFile, template, panat)
% Normalize structural image to an infant template using ANTS.
% For questions, please contact theodore.turesky@childrens.harvard.edu

if system('which antsRegistrationSyNQuick.sh') ~= 0
    error('ANTs functions not installed or not in path');
end


cmd = sprintf('antsRegistrationSyNQuick.sh -d 3 -f %s -m %s -o %s/babyReg',template, anatFile, panat); % use n4 bias corrected
system(cmd);


