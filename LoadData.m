%% load data
clear
data = load('../NeuroData/ta505_datasets/ta505_auditory.mat');
bad_channels = load('../NeuroData/ta505_datasets/ta505_bad_channels.mat');

data = data.nkdata;
bad_channels = bad_channels.bad_channels;
data.fs = 1000;

%% Sudha's code
% use trials <-- indices of trials not marked by experiemnters as
% noisy/innacurate/technical failure
% use_times <-- timestamps for use_trials articulations


use_trials = find(data.accuracy(:).*data.tech(:).*data.noise(:));
use_times = data.articulation(use_trials);
bad_channels.auditory
data.eeg = double(data.eeg(bad_channels.auditory,:));
data.ch_names = data.ch_names(bad_channels.auditory,:);

