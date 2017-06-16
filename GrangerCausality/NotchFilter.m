%% Notch filter attempt
disp('making notch filters...');
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
for filter = 1:number_of_harmonics
    [num(filter, :), den(filter, :)] = iirnotch(filter * wo, bw);
end 

disp('notch filters made');

%% filter each channel of deeg
disp('applying notch filters...');
notch_filtered_eeg = double(data.eeg);

%for every use_trial, throw it through every filter
for channel = 1:size(notch_filtered_eeg, 1)
    for filter = 1:number_of_harmonics
        fprintf('.');
        notch_filtered_eeg(channel, :) = filtfilt(num(filter,:), den(filter,:), notch_filtered_eeg(channel, :));
    end
    fprintf('\n');
end

clearvars num den bw number_of_harmonics q wo fo;
clear channel
clear filter
disp('notch filters applies');
%% Plot that shit
% disp('plotting...');
% [p, f] = periodogram (data.notch_filtered_eeg(1,:), [], [], 1000);
% for i = 2:size(data.notch_filtered_eeg, 1)
%     [tempp, tempf] = periodogram (data.notch_filtered_eeg(i,:), [], [], 1000);
%     p = p + tempp;
%     f = tempf;
% end
% p = p ./ size(data.notch_filtered_eeg, 1);
% dbp = 10*log10(p);
% plot (f, dbp);
% disp('plotted');