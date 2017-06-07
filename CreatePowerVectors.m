  

%create window for trial: ONLY USE_TRIALS
window_start = data.pulse_on(1);
window_end = data.pulse_on(2);

for channel = [1: size(data.filtered,1)]
    log_power = 0;
    total = 0;
    for j = [window_start:window_end]
        log_power = log_power + (filtered(channel, (trial-1)*window_size+j))^2;
        total = total + 1;
    end
    E(trial, channel) = log10(log_power/total);
end