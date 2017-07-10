
stim_trial_data = zeros(size(target_data, 1), size(data.use_trials, 1), TRIAL_LENGTH);
arti_trial_data = zeros(size(target_data, 1), size(data.use_trials, 1), TRIAL_LENGTH);
relative_articulation_time = zeros(size(data.use_trials,1),1);

for channel=1:size(target_data,1)
    for trial_num = 1:size(data.use_times, 1)
        stim_trial_data(channel, trial_num, :) = target_data(channel, data.use_times(trial_num) + STIM_TRIAL_DELAY: data.use_times(trial_num) + STIM_TRIAL_DELAY + TRIAL_LENGTH - 1);
        arti_trial_data(channel, trial_num, :) = target_data(channel, data.use_articulations(trial_num) - (ARTI_TRIAL_RETRO) + 1: data.use_articulations(trial_num) + (TRIAL_LENGTH - ARTI_TRIAL_RETRO));
    end
end

%%

articulation_delay = data.use_articulations(:) - data.use_times(:);
[trash, arti_sort_idx] = sort(articulation_delay);
arti_sorted_stim_trial_data = stim_trial_data(:, arti_sort_idx, :);
arti_sorted_arti_trial_data = arti_trial_data(:, arti_sort_idx, :);