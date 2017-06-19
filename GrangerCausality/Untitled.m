%% VAR with channel's K nearest neigbors


ORDER = 3;
channels_per_model = 2;
base_model = varm(channels_per_model, ORDER);

var_models = cell(size(windowed_eeg, 1) - (channels_per_model - 1),size(windowed_eeg,2));
model_count = 0;

for center_channel = 1 : size(windowed_eeg, 1) - 1
    model_count = model_count + 1;
    for window = 1:size(windowed_eeg,2)
        channel_range = center_channel: center_channel+1;
        var_models{model_count, window} = estimate(base_model, reshape(windowed_eeg(channel_range, window, :), [size(windowed_eeg, 3),channels_per_model]));
    end
    fprintf('.')
end

%%
numpaths = 1001;
numobs = 1000;
rng(1); % For reproducibility
[Y,E] = simulate(var_models{1,1},numobs,'NumPaths',numpaths);