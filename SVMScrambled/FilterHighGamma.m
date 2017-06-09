%% filter high gamma data

HIGH_GAMMA_LOWER = 70;
HIGH_GAMMA_UPPER = 150;

start_amt = 1;
end_amt = size(data.eeg,2);

data.filtered = zeros(size(data.eeg,1), size(data.eeg,2));
b = fir1(4000,[2*HIGH_GAMMA_LOWER/1000, 2*HIGH_GAMMA_UPPER/1000]);
H = freqz(b,1,1000);

count = 0;
for channel = [1: size(data.eeg,1)]
    %filter it
    data.filtered(channel, :) = filter(b, 1, data.eeg(channel, start_amt:end_amt));
    fprintf('.');
    count = count + 1;
    if(count == 20)
        count = 0;
        fprintf('\n');
    end  
end
fprintf('\n');

%% Graph

periodogram(data.filtered(1,:))
