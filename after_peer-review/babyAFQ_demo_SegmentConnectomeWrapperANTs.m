function fgFile_classified=babyAFQ_demo_SegmentConnectomeWrapperANTs(fatDir, ROIdir, sessid, runName, fgName, computeRoi,anatFile,asegFile, fivettFile)
%This is a wrapper around babyAFQ bundles segmentations
%fatDir: the data directory
%ROIdir: the dir where ROIs should be safed
%sessid: the subject directory name
%runName: the run directory name
%fgName: the name of the whole brain connectome
%computeROIs: should we compute ROIs? Relevant if the code had been run
%previously. Default is true.
%anatFile: optional. a t2 used for alignment. if no t2 is available, a b0
%can also be used.
if nargin < 6, computeRoi = true; end
if nargin < 5, fgName = 'lmax_curv1_post_life_et_it500.mat'; end

if computeRoi
    useRoiBasedApproach = true;
else
    useRoiBasedApproach = [2,0];
end

[~,fgNameWoExt] = fileparts(fgName);

fprintf('\nConnectome segment for (%s, %s, %s)\n',sessid,runName,fgNameWoExt);

cd(fullfile(fatDir,sessid,runName));
subdir=dir('*trilin');
runDir = fullfile(fatDir,sessid,runName,subdir.name);
afqDir = fullfile(runDir, 'fibers','afq');
if ~exist(afqDir, 'dir')
    mkdir(afqDir);
end


% Load connectome
wholeBrainfgFile = fullfile(runDir,'fibers', strcat(fgNameWoExt, '.mat'));
wholebrainFG = fgRead(wholeBrainfgFile);
%% classified the fibers
% Load the subject's dt6 file (generated from dtiInit).

dt = dtiLoadDt6(fullfile(runDir,'dt6.mat'));
% Segment the whole-brain fiber group into 20 fiber tracts
[fg_classified,fg_unclassified,classification,fg] = babyAFQ_SegmentFiberGroupsANTs(dt, wholebrainFG, ...
     [], useRoiBasedApproach, [], anatFile);


fg.classifiedWithBabyAFQIndex=classification.index;
fg.classifiedWithBabyAFQNames=classification.names;
clear wholebrainFG

%prepare VOF ROI
babyAFQ_PrepareVofROI(fatDir, sessid, runName, ROIdir, asegFile, fivettFile)
fg_classified = fg2Array(fg_classified);
%
%
% %% Identify VOF and pAF
[L_VOF, R_VOF, L_pAF, R_pAF, L_pAF_vot, R_pAF_vot] = babyAFQ_FindVOF(wholeBrainfgFile,...
    fg_classified(19),fg_classified(20),ROIdir,afqDir,[],[],dt);


fg_classified(23) = L_VOF;
fg_classified(24) = R_VOF;

%pAF
fields = {'coordspace'};
try
    L_pAF = rmfield(L_pAF,fields);
    R_pAF = rmfield(R_pAF,fields);
catch
end

fields = {'type'};
try
    L_pAF = rmfield(L_pAF,fields);
    R_pAF = rmfield(R_pAF,fields);
catch
end

fields = {'fiberNames'};
try
    L_pAF = rmfield(L_pAF,fields);
    R_pAF = rmfield(R_pAF,fields);
catch
end

fields = {'fiberIndex'};
try
    L_pAF = rmfield(L_pAF,fields);
    R_pAF = rmfield(R_pAF,fields);
catch
end


fields = {'coordspace'};
try
    L_pAF_vot = rmfield(L_pAF_vot,fields);
    R_pAF_vot = rmfield(R_pAF_vot,fields);
catch
end

fields = {'type'};
try
    L_pAF_vot = rmfield(L_pAF_vot,fields);
    R_pAF_vot = rmfield(R_pAF_vot,fields);
catch
end

fields = {'fiberNames'};
try
    L_pAF_vot = rmfield(L_pAF_vot,fields);
    R_pAF_vot = rmfield(R_pAF_vot,fields);
catch
end

fields = {'fiberIndex'};
try
    L_pAF_vot = rmfield(L_pAF_vot,fields);
    R_pAF_vot = rmfield(R_pAF_vot,fields);
catch
end


fg_classified(25) = L_pAF;
fg_classified(26) = R_pAF;

% pAF_vot

fg_classified(27) = L_pAF_vot;
fg_classified(28) = R_pAF_vot;

% merge pAF and pAFvot
%fg_classified(29) = fgUnion(L_pAF,L_pAF_vot);
%fg_classified(30) = fgUnion(R_pAF,R_pAF_vot);

% save file
fgFile_classified = fullfile(afqDir, [fgNameWoExt, '_classified_withBabyAFQ.mat']);
S.fg = fg_classified;
save(fgFile_classified,'-struct','S');

% % save unclassified fibers
fgFile_unclassified = fullfile(afqDir, [fgNameWoExt,'_unclassified_withBabyAFQ.mat']);
S.fg = fg_unclassified;
save(fgFile_unclassified,'-struct','S');

% % save unclassified fibers
fgFile = (fullfile(afqDir, [fgNameWoExt,'_allFibers_babyAFQ.mat']));
S.fg = fg;
save(fgFile,'-struct','S');
clear S;

end

