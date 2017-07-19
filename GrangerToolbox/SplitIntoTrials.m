target_data = data.eeg; %full time series,, (channel, time)

TRIAL_LENGTH = 1500
trial_data= zeros(size(target_data, 1), TRIAL_LENGTH,size(data.use_trials, 1));
relative_articulation_time = zeros(size(data.use_trials,1),1);

for channel=1:size(target_data,1)
    for trial_num = 1:size(data.use_times, 1)
        trial_data(channel, :, trial_num) = target_data(channel, data.use_times(trial_num): data.use_times(trial_num) + TRIAL_LENGTH - 1);
        relative_articulation_time(trial_num) = data.use_articulations(trial_num) - data.use_times(trial_num);
    end
end