target_data = trial_z_score;

for channel = 1:size(target_data,1)
    for trial = 1:size(target_data,2)
        target_data(channel, trial, :) = filter((1/100) * ones(100,1), 1, target_data(channel, trial, :));
    end
end
%%
centroid_location = zeros(size(target_data,1), size(target_data,2));

for channel = 1:size(target_data, 1)
    for trial = 1:size(target_data,2)
        numer = 0; %Sum: f(x)*x
        denom = 0; %Sum: x
        for time = 1:size(target_data,3)
            numer = numer + ((target_data(channel, trial, time) * time).^2);
            denom = denom + (target_data(channel, trial, time).^2);
            if mod(time, 500) == 0
                fprintf('.');
            end
        end
        fprintf('done trial %i\n', trial);
        centroid_location(channel, trial) = numer / denom;
    end
    fprintf('\n ------------------ Channel %i done-------------------------\n', channel);
end
%%

h = heatmap(centroid_location, 'colormap', colormap('parula'), 'GridVisible', 'off')
h.title('Signal Centroid by Channel and trial')
h.xlabel('Trial (Ordered by Trial Number)');
h.ylabel('Channel (Ordered by Channel Number)');
%%
histogram(centroid_location) % Looks like  random noise

%%
for channel = 1:size(centroid_location, 1)
    mene = mean(centroid_location(channel, :), 2);
    med = median(centroid_location(channel, :), 2);
    lameness(channel) = mene - med;
end

%% sort by avg centroid
% NOTE THIS BLOCK ADDS A TRIAL
centroid_location_with_avg_trial = centroid_location;
centroid_location_with_avg_trial(:, size(target_data, 2) + 1) = mean(centroid_location_with_avg_trial');

[sorted_centroid_location, sorted_CL_indices] = sortrows(centroid_location_with_avg_trial, size(centroid_location_with_avg_trial,2));

h = heatmap(sorted_centroid_location, 'colormap', colormap('parula'), 'GridVisible', 'off')
h.title('Signal Centroid by Channel and trial')
h.xlabel('Trial (Ordered by Trial Number)');
h.ylabel('Channel (Ordered by average centroid location)');

%% sort trial-by-trial by exact centroid, color represent rank in "sort by avg centroid"
per_trial_ordering = zeros(size(sorted_centroid_location));

for trial = 1:size(sorted_centroid_location,2)
    [temp, per_trial_ordering(:,trial)] = sortrows(sorted_centroid_location, trial);
end

h = heatmap(per_trial_ordering, 'colormap', colormap('parula'), 'GridVisible', 'off')
h.title('Signal Centroid by position and trial')
h.xlabel('Trial (Ordered by Trial Number)');
h.ylabel('Channel (Ordered per trial by centroid order)');
%% Distinguish Scramble vs Non Scramble
per_trial_ordering_s_ns = zeros(size(sorted_centroid_location));
[tmp, s_ns_indices] = sort(data.use_scramble);

new_trial = 0;
for old_trial = s_ns_indices
    new_trial = new_trial + 1;
    if(new_trial == length(data.use_scramble) - nnz(data.use_scramble))
        new_trial = new_trial + 1;
    end
    per_trial_ordering_s_ns(:, new_trial) = per_trial_ordering(:, old_trial);
end


h = heatmap(per_trial_ordering_s_ns, 'colormap', colormap('parula'), 'GridVisible', 'off')

%% centroid location, trials sortedw by articulation time
[tmp, articulation_index] = sort(relative_articulation_time);

articulation_ordering = zeros(size(centroid_location));
new_trial = 0;
for old_trial = s_ns_indices
    new_trial = new_trial + 1;
    articulation_ordering(:, new_trial) = centroid_location(:, old_trial);
end

h = heatmap(articulation_ordering(:,1:247,:), 'colormap', colormap('parula'), 'GridVisible', 'off')