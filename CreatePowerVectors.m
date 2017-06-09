  
%create window for trial: ONLY USE_TRIALS
clear E;
trial_num = 0;

for trial_val = transpose(data.use_trials)
    if(trial_val ~= 327)
    trial_num = trial_num+1;
    window_start = data.articulation(trial_val);
    window_end = data.pulse_on(trial_val+1);

    for channel = [1: size(data.filtered,1)]
        log_power = 0;
        total = 0;
        for j = [window_start:window_end]
            log_power = log_power + (data.filtered(channel, j))^2;
            total = total + 1;
        end
        E(trial_num, channel) = log_power/total;
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



