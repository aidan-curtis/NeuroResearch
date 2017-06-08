%% Load the data
% Data should be stored in '../NeuroData/ta505_datasets/'
disp('Loading data...')
run('LoadData.m');
disp('Data Loaded');
%{
New/updated variables:
bad_channels -- struct -- the contents of the bad_channels.mat file
data -- struct -- the contents of the relevant dataset (adjustable)
data.use_trials -- 34x1 double --indecies of data.eeg labeled by doc as not sucky
data.use_times -- 34x1 double -- the corresponding timestamps to use_trials
data.fs -- sampling frequency (1000 Hz)
UPDATED: data.eeg -- values labeled bad in bad_channels removed
UPDATED: data.ch_names -- updated accordingly
%}

%% Filter out harmonics of 60 Hz because AC
disp('Filtering notches...');
run('NotchFilter.m');
disp('Notches Filtered');
%{
New/updated variables:
data.notch_filtered_eeg created
UPDATE data.eeg <-- data.notch_filtered_eeg
%}


%% Band Pass Filter High Gamma frequency
disp('Filtering High Gamma...');
run('FilterHighGamma.m');
disp('High Gamma Filtered.');
%{
New/updated variables: filtered -- a 2D array with the same dimensions as
the data that has filtered out everything but 70-170 Hz
%}

%% create power vectors
disp('Creating power vectors...');
run('CreatePowerVectors.m');
disp('Power vectors created.');
%{
New/updated variables: 
data.E -- power vectors
data.use_scramble -- logical for whether or not the given trial in use_trial is scramble
%}


%% T  test for most diagnostic nodes give a vector
disp('Selecting Nodes...');
run('NodeSelection.m');
disp('Nodes Selected');
%{
New/updated variables: 
data.good_channels -- the channel indecies of the n channels with the
hightes t values
%}


