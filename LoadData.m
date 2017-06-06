%% load data
clear
data = load('../NeuroData/ta505_datasets/ta505_auditory.mat');
bad_channels = load('../NeuroData/ta505_datasets/ta505_bad_channels.mat');

data = data.nkdata;
bad_channels = bad_channels.bad_channels;

%% Sudha's code
% use trials <-- indices of trials not marked by experiemnters as
% noisy/innacurate/technical failure
% use_times <-- timestamps for use_trials articulations


use_trials = find(data.accuracy(:).*data.tech(:).*data.noise(:));
use_times = data.articulation(use_trials);
bad_channels.auditory
data.eeg = data.eeg(bad_channels.auditory,:);
data.ch_names = data.ch_names(bad_channels.auditory,:);

%% clean data

%select bad channels



[channel_size, ~] = size(data.eeg)


count = 1;
[pxx, w] = periodogram(double(data.eeg(1, :)));
periodograms = pxx;

plot(abs(fft(double(data.eeg(1,:)))))
figure
periodogram(double(data.eeg(1, :)))
% plot(w, periodograms);
% 
% figure;
% for channel = [2:channel_size]
%     [pxx, w] = periodogram(double(data.eeg(channel, :)));
%     plot(w,10*log10(pxx))
%     periodograms = periodograms + pxx;
%     count = count+1;
% end
% 
% plot(w, 10*log10(periodograms));



%% filter high gamma data

start_amt = 1
end_amt = 63800
for channel = [1: 2]
    
%filter it
b = fir1(480,[0.175 0.425]);
H = freqz(b,1,400);
max_ecog = max(abs(fft(ecog(channel, start_amt:end_amt))));
filtered = filter(b, 1, ecog(channel, start_amt:end_amt));
size(filtered)
filtered = downsample(filtered, 2)
spectrogram(filtered)
% spectrogram(filtered)

%making the power vector
window_size = 50;
[~, et] = size(filtered);

for i = [1:(et/window_size)]
    %get power of window
    log_power = 0;
    for j = [1:window_size]
       log_power = log_power+ (filtered((i-1)*window_size+j))^2;
    end
    E(i, channel) = log10(log_power);
end
disp('calculating vectors')
disp(channel)
end


%% Get frequency vectors

start_amt = 1
end_amt = 638000
for channel = [1: 2]
    
%filter it
b = fir1(480,[0.175 0.425]);
H = freqz(b,1,400);
max_ecog = max(abs(fft(ecog(channel, start_amt:end_amt))));
filtered = filter(b, 1, ecog(channel, start_amt:end_amt));
size(filtered)
filtered = downsample(filtered, 2)
spectrogram(filtered)
% spectrogram(filtered)

%making the power vector
window_size = 50;
[~, et] = size(filtered);

for i = [1:(et/window_size)]
    %get power of window
    log_power = 0;
    for j = [1:window_size]
       log_power = log_power+ (filtered((i-1)*window_size+j))^2;
    end
    E(i, channel) = log10(log_power);
end
disp('calculating vectors')
disp(channel)
end

%% Get power of the signal at different frequencies

centers = [70, 73.0, 79.5, 87.8, 96.9, 107.0, 118.1, 130.4, 144.0]
sizes = []
[~, sc] = size(centers);

for a = [2: sc]
    sizes(a-1) = centers(a)-centers(a-1)
end

%% Make filters for spectrums


interval = ecog(1, 1100:2100);

[~, N] = size(interval)


%LENGTH MUST BE 100, OTHERWISE, YOU MUST CHANGE 70 and 170
b = fir1(580,[70/N, 170/N]);
H = freqz(b,1, N);


filtered = filter(b, 1, interval)

plot(filtered)




% plot(interval)
for channel = [1: 2]
        
        
    
%     for center = centers
        center = 1;

        bottom = centers(center)-sizes(center)/2;
        top = centers(center)+size(center)/2;

        [~, N] = size(interval);
        

%     end
    
end

