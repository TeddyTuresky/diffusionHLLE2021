function mrtrix2babyAFQ(fold1, fg_tck, bzero, brain, aseg, fivett, ants, gcc)

% Runs babyAFQ functions

setenv('LD_LIBRARY_PATH', [gcc getenv('LD_LIBRARY_PATH')]);
libpath = getenv('LD_LIBRARY_PATH');
disp(libpath)

% Convert *.tck wholebrain tractography to *.mat for AFQ
[pp,~,~] = fileparts(fg_tck);
dti_end_tract(fg_tck, fullfile(pp, 'WholeBrainFG.mat'));

% Setup for and run babyAFQ fiber tract segmentation
s = regexp(fold1, '/', 'split');
sessid = s{1,end};
bbDir = strrep(fold1, ['/' sessid], '');

if(ants)
    babyAFQ_demo_SegmentConnectomeWrapperANTs(bbDir, fullfile(bbDir, sessid, 'dtitrilin', 'babyAFQROIs'), ...
    sessid, 'dtitrilin', 'WholeBrainFG.mat', 'true', brain, aseg, fivett);
else
    babyAFQ_demo_SegmentConnectomeWrapper(bbDir, fullfile(bbDir, sessid, 'dtitrilin', 'babyAFQROIs'), ...
    sessid, 'dtitrilin', 'WholeBrainFG.mat', 'true', bzero, aseg, fivett);
end

babyAFQ_demo_CleanConnectomeWrapper(bbDir, sessid, 'dtitrilin', 'WholeBrainFG_classified_withBabyAFQ.mat');

% Render test tracts
fig_out = [fold1 '/tract_renderings'];
if isfolder(fig_out) == 0
    mkdir(fig_out);
end
fgIn = fullfile(fold1, 'dtitrilin', 'fibers', 'afq', 'WholeBrainFG_classified_withBabyAFQ_clean.mat');

mrtrix_babyAFQ_render(fgIn, bzero, fig_out);

end