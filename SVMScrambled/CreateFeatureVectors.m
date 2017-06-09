%create window for trial: ONLY USE_TRIALS

%indexed as data_matrix (channel, time, freqbin)
data_matrix = data.filtered;
feature = @(channel, time_window, freq_bin, value_matrix) log10(mean(value_matrix(channel,time_window).^2));
clear E;

trial_num = 0;
NUMBER_OF_WINDOWS = 3;
for trial_val = transpose(data.use_trials)
    trial_num = trial_num+1;
    
    trial_start = data.pulse_on(trial_val);
    trial_end = data.articulation(trial_val);
    window_length = floor((trial_end - trial_start) / NUMBER_OF_WINDOWS);
    for channel = [1: size(data.filtered,1)]
        for window = 1:NUMBER_OF_WINDOWS
            window_start = trial_start + (window * (window_length -1));
            window_end = trial_start + (window * window_length);
            for freq_bin = 1:size(data_matrix, 3)
                E(trial_num, window, channel, freq_bin) = feature(channel, window_start:window_end, freq_bin, data.filtered);
        end
    end
end

data.E = E;
%% Create use_scramble
%use_scramble is an array that contains all of the scramble data on whether
%a use_trial is scrambled or not
total = 0;
for trial = [1:size(data.scramble,1)]
    if(~isempty(find(data.use_trials == trial)))
        total = total+1;
        data.use_scramble(total) = data.scramble(trial);
    end
end
data.use_scramble = logical(data.use_scramble);

%% VIsualize

group = zeros(1, length(data.use_scramble) * length(~data.use_scramble));
k = 1;
for i = data.E(data.use_scramble)
    for j = data.E(~data.use_scramble)
        group (k) = i* j;
        k = k + 1;
    end
end

