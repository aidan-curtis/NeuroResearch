%% filter high gamma data

start_amt = 1;
end_amt = size(data.eeg,2);
data.filtered = zeros(size(data.eeg,1), size(data.eeg,2));
b = fir1(4000,[2*70/1000, 2*170/1000]);
H = freqz(b,1,1000);
for channel = [1: size(data.eeg,1)]
    %filter it
    data.filtered(channel, :) = filter(b, 1, data.eeg(channel, start_amt:end_amt));
end
%% Graph

periodogram(data.filtered(1,:))