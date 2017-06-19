%% filter high gamma data
target_data = data.eeg;

HIGH_GAMMA_LOWER = 70;
HIGH_GAMMA_UPPER = 150;

start_amt = 1;
end_amt = size(target_data,2);

filtered_eeg = zeros(size(target_data,1), size(target_data,2));
b = fir1(4000,[2*HIGH_GAMMA_LOWER/1000, 2*HIGH_GAMMA_UPPER/1000]);
H = freqz(b,1,1000);

count = 0;
for channel = [1: size(target_data,1)]
    %filter it
    filtered_eeg(channel, :) = filter(b, 1, target_data(channel, start_amt:end_amt));
    fprintf('.');
    count = count + 1;
    if(count == 20)
        count = 0;
        fprintf('\n');
    end  
end
fprintf('\n');

%% Graph

periodogram(filtered_eeg(1,:))
