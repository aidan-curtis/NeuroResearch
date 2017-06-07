%% Deouble eeg
deeg = double(data.eeg);

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
data.fs = 1000;
%desired harmonic to filter out
fo = 60;
%normalized frequency to filter out
wo = fo/(data.fs/2);
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

clearvars den bw number_of_harmonics q wo;

%% filter each channel of deeg
fdeeg = zeros (97, 638000);

%for every use_trial, throw it through every filter
for i = 1:length(use_trials)
    fdeeg(use_trials(i), :) = filtfilt(num(1,:), den(1,:), deeg(use_trials(i), :));
    for j = 2:number_of_harmonics
        fdeeg(use_trials(i), :) = filtfilt(num(j,:), den(j,:), fdeeg(use_trials(i), :));
    end
end


clear i
clear j

%% Plot that shit
% [p, f] = periodogram (fdeeg(use_trials(1),:), [], [], 1000);
% for i = 2:length(use_trials)
%     [tempp, tempf] = periodogram (fdeeg(use_trials(i),:), [], [], 1000);
%     p = p + tempp;
%     f = tempf;
% end
% p = p ./ length(use_trials);
% dbp = 10*log10(p);
% plot (f, dbp);