%% basic periodogram
% trial_num = use_trials(5);
% pxx = periodogram (deeg(trial_num,:));
% plot(pxx)
% [pxx, f] = periodogram (deeg(use_trials(5),:), [], [], 1000);
% plot (f, 10*log10(pxx))

%% average periodograms
% [p, f] = periodogram (deeg(use_trials(5),:), [], [], 1000);
% for i = 2:34
%     [tempp, tempf] = periodogram (deeg(use_trials(i),:), [], [], 1000);
%     p = p + tempp;
%     f = tempf;
% end
% p = p ./ 34;
% dbp = 10*log10(p);
% plot (f, dbp);

%% Notch filter attempt

%sampling frequency
a_data.fs = 1000;
%desired harmonic to filter out
fo = 60;
%normalized frequency to filter out
wo = fo/(a_data.fs/2);
%"quality"
q = 25;
%bandwidth equasion based on quality
bw = wo/q;

%number of times the harmonic appears in the sampling range
number_of_harmonics = floor(1/wo);

%make the filters
num = zeros(number_of_harmonics, 3);
den = zeros(number_of_harmonics, 3);
for i = 1:number_of_harmonics
    [num(i, :), den(i, :)] = iirnotch(i * wo, bw);
end 



%% filter each channel of deeg
a_data.notch_filtered_eeg = double(a_data.eeg);

%for every use_trial, throw it through every filter
for i = 1:length(a_use_trials)
    for j = 1:number_of_harmonics
        a_data.notch_filtered_eeg(a_use_trials(i), :) = filtfilt(num(j,:), den(j,:), a_data.notch_filtered_eeg(a_use_trials(i), :));
    end
end

clearvars num den bw number_of_harmonics q wo fo;
clear i
clear j

%% Plot that shit
% [p, f] = periodogram (a_data.notch_filtered_eeg(a_use_trials(1),:), [], [], 1000);
% for i = 2:length(a_use_trials)
%     [tempp, tempf] = periodogram (a_data.notch_filtered_eeg(a_use_trials(i),:), [], [], 1000);
%     p = p + tempp;
%     f = tempf;
% end
% p = p ./ length(a_use_trials);
% dbp = 10*log10(p);
% plot (f, dbp);