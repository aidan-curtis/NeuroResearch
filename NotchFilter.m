%% Deouble eeg
deeg = double(data.eeg);

%% basic periodogram
trial_num = use_trials(5);
pxx = periodogram (deeg(trial_num,:));
plot(pxx)
[pxx, f] = periodogram (deeg(use_trials(5),:), [], [], 1000);
plot (f, 10*log10(pxx))

%% average periodograms
[p, f] = periodogram (deeg(use_trials(5),:), [], [], 1000);
for i = 2:34
    [tempp, tempf] = periodogram (deeg(use_trials(i),:), [], [], 1000);
    p = p + tempp;
    f = tempf;
end
p = p ./ 34;
dbp = 10*log10(p);
plot (f, dbp);

%% Notch filter attempt

fs = 1000;
fo = 60;
wo = fo/(fs/2);
q = 25;
bw = wo/q;

number_of_harmonics = floor(1/wo);

num = zeros(number_of_harmonics, 3);
den = zeros(number_of_harmonics, 3);

for i = 1:number_of_harmonics
    [num(i, :), den(i, :)] = iirnotch(i * wo, bw);
end 


%% filter each channel of deeg
fdeeg = zeros (97, 638000);

for i = 1:34
    fdeeg(use_trials(i), :) = filtfilt(num(1,:), den(1,:), deeg(use_trials(i), :));
    for j = 2:number_of_harmonics
        fdeeg(use_trials(i), :) = filtfilt(num(j,:), den(j,:), fdeeg(use_trials(i), :));
    end
end

%% Plot that shit
[p, f] = periodogram (fdeeg(use_trials(1),:), [], [], 1000);
for i = 2:34
    [tempp, tempf] = periodogram (fdeeg(use_trials(i),:), [], [], 1000);
    p = p + tempp;
    f = tempf;
end
p = p ./ 34;
dbp = 10*log10(p);
plot (f, dbp);


%% Aidan's stuff from old LoadData.m
% clean data

%select bad channels
aidan_bad = [125, 103, 97, 51];


count = 1;
[pxx, w] = periodogram(ecog(1, :));
periodograms = 10*log10(pxx);
for channel = [2:125]
    if(~ismember(bad_channels, channel))
       [pxx, w] = periodogram(ecog(channel, :));
       plot(w,10*log10(pxx))
       periodograms = periodograms + 10*log10(pxx);
       count = count+1;
    end
end

plot(w, periodograms);



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

