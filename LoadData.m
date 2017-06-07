%% load data
clear
a_data = load('../NeuroData/ta505_datasets/ta505_auditory.mat');
c_data = load('../NeuroData/ta505_datasets/ta505_common.mat');
bad_channels = load('../NeuroData/ta505_datasets/ta505_bad_channels.mat');

a_data = a_data.nkdata;
c_data = c_data.nkdata;
bad_channels = bad_channels.bad_channels;
a_data.fs = 1000 / c_data.ms_per_sample;
c_data.fs  = 1000 / c_data.ms_per_sample;
%% Sudha's code
% use trials <-- indices of trials not marked by experiemnters as
% noisy/innacurate/technical failure
% use_times <-- timestamps for use_trials articulations

a_use_trials = find(a_data.accuracy(:).*a_data.tech(:).*a_data.noise(:));
a_use_times = a_data.articulation(a_use_trials);
a_data.eeg = double(a_data.eeg(bad_channels.auditory,:));
a_data.ch_names = a_data.ch_names(bad_channels.auditory,:);

c_use_trials = find(c_data.accuracy(:).*c_data.tech(:).*c_data.noise(:));
c_use_times = c_data.articulation(c_use_trials);
c_data.eeg = double(c_data.eeg(bad_channels.common,:));
c_data.ch_names = c_data.ch_names(bad_channels.common,:);
