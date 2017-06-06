%% filter high gamma data

start_amt = 1;
end_amt = 63800;
for channel = [1: size(data.eeg,2)]
    
    %filter it
    b = fir1(480,[0.175 0.425]);
    H = freqz(b,1,400);
    max_ecog = max(abs(fft(data.eeg(channel, start_amt:end_amt))));
    filtered = filter(b, 1, data.eeg(channel, start_amt:end_amt));
    spectrogram(filtered);
end