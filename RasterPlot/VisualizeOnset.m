for channel = sorted_CL_indices'
    mean_across_trials(channel, :) = mean(trial_z_score(channel, :, :).^2, 2);
end

%%
count = count +1
subplot(2,1,1)
plot(mean_across_trials(count,:))
subplot(2,1,2)
%colormap('jet')
%imagesc(reshape(trial_z_score(count,:,:),[size(trial_z_score,2) TRIAL_LENGTH]));
plot(abs(fft(mean_across_trials(count,:))));
xlim([500, 1500])
ylim([0 100])
%%
%VERY BIASED list of channels that dont look like noise
wave_channels = [8, 9, 29, 30, 31, 32, 33, 34, 35, 42, 43, 44, 48, 49, 50, 51, 52, 53, 57, 58, 59, 60, 76, 78, 79, 80, 81, 84, 85 82, 83, 96, 97, 98, 99, 100, 104, 107];

%%
target_data = mean_across_trials;

wc_centroid_location = zeros(107, 1);

count = 0;
for channel = 1:107
    count = count + 1;
    numer = 0; %Sum: f(x)*x
    denom = 0; %Sum: x
    for time = 1:size(target_data,2)
        numer = numer + abs((target_data(channel, time) * time));
        denom = denom + abs(target_data(channel, time));
        if mod(time, 500) == 0
            fprintf('.');
        end
    end
    fprintf('done trial %i\n', trial);
    wc_centroid_location(count) = numer / denom;
    fprintf('\n ------------------ Channel %i done-------------------------\n', channel);
end
plot (wc_centroid_location,'-o', 'MarkerIndices', wave_channels)