  

%create window for trial: ONLY USE_TRIALS
window_start = 1
window_end = 20
for channel = [1: size(data.eeg,1)]
% making the power vector

    et = size(data.filtered, 2);
   
    %get power of window
    log_power = 0;
    for j = [1:window_size]
        log_power = log_power + (filtered(channel, (trial-1)*window_size+j))^2;
    end
    E(trial, channel) = log10(log_power);
end