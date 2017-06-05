%% load path for iELVis
addpath(genpath('./iELVis-master'))
savepath

global globalFsDir;
globalFsDir='/Applications/freesurfer/subjects/';

%% Move data to freesurfer path


%% Testing visualization


cfg=[];
cfg.view='l';
cfg.showLabels='y';
cfg.title='Electrode Placement'; 
cfgOut=plotPialSurf('PT001',cfg);
