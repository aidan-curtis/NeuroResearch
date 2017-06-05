%% load data
data = load('ta505_auditory.mat');
ecog = data.nkdata.eeg;
clear data;

%% clean data

%remove bad channels
