

spectogram(data.eeg(12));


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

