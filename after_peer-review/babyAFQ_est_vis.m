function [fa, md, rd, ad] = babyAFQ_vis_lafHLE(sub_dir, tract, nodes)
% Renders fibers with tubes and signifcant nodes on mesh background.
% Elements taken from http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example_GroupComparison


% Load the cleaned segmented fibers for the first control subject
% fg = dtiReadFibers(fullfile(sub_dir, 'fibers', 'afq', 'WholeBrainFG_classified_withBabyAFQ_clean.mat')); 
load(fullfile(sub_dir, 'fibers', 'afq', 'WholeBrainFG_classified_withBabyAFQ_clean.mat')); 


% Load the subject's dt6 file
dt = dtiLoadDt6(fullfile(sub_dir, 'dt6.mat'));

roiDir = fullfile(sub_dir, 'babyAFQROIs');

% Compute Tract Profiles with 100 nodes
numNodes = 100;
[fa, md, rd, ad, cl, volume, TractProfile] = babyAFQ_ComputeTractProperties(fg, ...
                                        dt, ...
                                        numNodes, ...
                                        1, ...
                                        sub_dir, ...
                                        roiDir, ...
                                        1);

% Specify significant nodes
tst=zeros(1,100);
tst(1,:)=5;
tst(1,nodes)=2; 

mymap = [153/255 51/255 255/255; 1 1 1]; % first row is band, second row is tube

TractProfile(tract) = AFQ_TractProfileSet(TractProfile(tract),'vals','Tstat',tst);... 
    AFQ_RenderFibers(fg(tract),'color',... % first color is color of fibers
    [153/255 51/255 255/255],'tractprofile',TractProfile(tract), ... 
    'val','Tstat','radius',[0.5 5.5],'numfibers',150,'cmap',mymap,'crange',[0.5 5]); 

axis image
axis off
set(gcf, 'color', 'none');  
