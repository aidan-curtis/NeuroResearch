%Load the data
% Data should be stored in '../NeuroData/ta505_datasets/'
run('LoadData.m');
%{
New/updated variables:
bad_channels -- struct -- the contents of the bad_channels.mat file
data -- struct -- the contents of the auditory.mat file
use_trials -- 34x1 double --indecies of data.eeg labeled by doc as not sucky
use_times -- 34x1 double -- the corresponding timestamps to use_trials
data.fs -- sampling frequency (1000 Hz)
UPDATED: data.eeg -- values labeled bad in bad_channels removed
UPDATED: data.ch_names -- updated accordingly
%}

%Filter out harmonics of 60 Hz because AC
run('NotchFilter.m');
%{
New/updated variables:
deeg -- 97x638000 double -- shorthand for double(data.eeg)
fo, wo, q, bw, number_of_harmonics -- temporary variable for filter construction
num, den -- the filter itself
fdeeg -- 97x638000 double -- the filtered version of deeg
%}


%Band Pass Filter High Gamma frequency
run('FilterHighGamma.m');
%{
New/updated variables: filtered -- a 2D array with the same dimensions as
the data that has filtered out everything but 70-170 Hz
%}



