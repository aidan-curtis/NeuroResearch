for channel = [1:size(trial_z_score,1)]
    mean_across_trials(channel, :) = mean(trial_z_score(channel, :, :).^2, 2);
end

%% Visualize
B = 1/10*ones(10,1);
for current = [1:size(trial_z_score,1)]
      out(current, :) = filter(B,1,mean_across_trials(current, :));
end


%% getting peaks
for channel = [1:size(trial_z_score,1)]
    for trial = [1: size(trial_z_score, 2)]
        [~, index(channel, trial)] = max(out(channel, trial, :));
    end
end


%% Make movie

wave_channels = [8, 9, 29, 30, 31, 32, 33, 34, 35, 42, 43, 44, 48, 49, 50, 51, 52, 53, 57, 58, 59, 60, 76, 78, 79, 80, 81, 84, 85 82, 83, 96, 97, 98, 99, 100, 104, 107];
count = 0
channel_names = data.ch_names(wave_channels, :)

for wave_channel = wave_channels
    count = count + 1
    [~, a(count)] = max(out(wave_channel, :));
    use_wave_channel(count, :) = out(wave_channel, :);
    selected_channels(count, :) = channel_names(count, :)
end
[~, sorted_index] = sort(a)
disp(selected_channels(sorted_index, :))
count = 0
for wave_index = sorted_index
    count = count + 1;
    plot(use_wave_channel(wave_index,:),'-s','MarkerIndices',[a(wave_index)],'MarkerFaceColor','red','MarkerSize',15);
    images(count) = getframe;
end


%% Play movie

movie(images, size(wave_channels(end-4:end), 1), 5)

%% Visualize with a low pass filter
sorted_index = sort(index(wave_channels, :),1)
h = heatmap(sorted_index(:, :), 'colormap', colormap('parula'))
h.GridVisible = 'off'




