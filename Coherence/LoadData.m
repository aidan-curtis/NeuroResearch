%% load data
% use trials <-- indices of trials not marked by experiemnters as
% noisy/innacurate/technical failure
% use_times <-- timestamps for use_trials articulations
%updates channels to ignore bad channels

clear

experiment = 'common'

temp_bad_channels = load('../NeuroData/ta505_datasets/ta505_bad_channels.mat');
bad_channels = temp_bad_channels.bad_channels;

if(strcmp(experiment, 'auditory'))
    temp_data = load('../NeuroData/ta505_datasets/ta505_auditory.mat');
    data = temp_data.nkdata;
    data.fs  = 1000 / data.ms_per_sample;
    data.use_trials = find(data.accuracy(:).*data.tech(:).*data.noise(:));
    data.use_times = data.articulation(data.use_trials);
    data.eeg = double(data.eeg(bad_channels.auditory,:));
    data.ch_names = data.ch_names(bad_channels.auditory,:); 
end

if(strcmp(experiment, 'common'))
    temp_data = load('../NeuroData/ta505_datasets/ta505_common.mat');
    data = temp_data.nkdata;
    data.fs  = 1000 / data.ms_per_sample;
    data.use_trials = find(data.accuracy(:).*data.tech(:).*data.noise(:));
    data.use_times = data.articulation(data.use_trials);
    data.eeg = double(data.eeg(bad_channels.common,:));
    data.ch_names = data.ch_names(bad_channels.common,:);
end