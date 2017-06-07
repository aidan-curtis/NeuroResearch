    
for channel = [1: size(data.eeg,1)]
% making the power vector
    window_size = 50;
    et = size(data.filtered, 2);
    
    for trial = [1:(et/window_size)]
        %get power of window
        log_power = 0;
        for j = [1:window_size]
<<<<<<< HEAD
            log_power = log_power + (filtered(channel, (trial-1)*window_size+j))^2;
=======
            log_power = log_power + (data.filtered(channel, (i-1)*window_size+j))^2;
>>>>>>> origin/dorandoran
        end
        E(trial, channel) = log10(log_power);
    end
    
end