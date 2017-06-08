%time domain windows for sub-trial resolution
NUMBER_OF_WINDOWS = 3;

%create window for trial: ONLY USE_TRIALS

trial_num = 0;
E = zeros(length(transpose(data.use_trials)),size(data.filtered,1), NUMBER_OF_WINDOWS);



for trial_val = transpose(data.use_trials)
    
    trial_num = trial_num+1;
    
    trial_start = data.pulse_on(trial_val);
    trial_end = data.articulation(trial_val);
    trial_length = trial_end-trial_start;
    window_length = trial_length/NUMBER_OF_WINDOWS;
    current_time = trial_start;
    
    for window = 1:NUMBER_OF_WINDOWS
        for channel = [1: size(data.filtered,1)]
            log_power = 0;
            total = 0;
            for j = [current_time:current_time + window_length]
                log_power = log_power + (data.filtered(channel, int64(j)))^2;
                total = total + 1;
            end
            E(trial_num, channel, window) = log10(log_power/total);
        end
        
        current_time =  current_time + window_length;
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



