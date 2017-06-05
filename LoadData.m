%% load data
data = load('../NeuroData/ta505_datasets/ta505_auditory.mat');
ecog = double(data.nkdata.eeg);

%% clean data

%select bad channels
bad_channels = [125, 103, 97, 51];

%% filter high gamma data

start_amt = 1
end_amt = 63800
for channel = [1: 125]
b = fir1(480,[0.175 0.425]);
H = freqz(b,1,400);
max_ecog = max(abs(fft(ecog(channel, start_amt:end_amt))));
filtered = filter(b, 1, ecog(channel, start_amt:end_amt));
window_size = 50;
[~, et] = size(filtered );

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


%% Plotting power vectors


plot(E(: , 117))
