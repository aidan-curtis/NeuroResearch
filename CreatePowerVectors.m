    
for channel = [1: size(data.eeg,2)]
% making the power vector
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
    
    end