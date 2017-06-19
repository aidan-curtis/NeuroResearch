trial_z_score = zeros( size(trial_data));
for channel = 1:size(trial_data, 1)
    for trial = 1:size(trial_data,2)
        mean_power = mean( reshape( trial_data(channel, trial, :), [1 TRIAL_LENGTH]));
        variance = std( reshape( trial_data(channel, trial, :), [1 TRIAL_LENGTH]));
        trial_z_score(channel, trial, :) = (trial_data(channel, trial, :) - mean_power) / variance;
    end
end
%%
h = heatmap(reshape(trial_z_score(7, :, 1001:2000), [247 1000]), 'colormap', colormap('parula'), 'GridVisible', 'off')
