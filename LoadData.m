%% load data
data = load('../NeuroData/ta505_datasets/ta505_auditory.mat');
ecog = data.nkdata.eeg;
disp('hi')

%% clean data
plot(ecog(124, :))
%remove bad channels
