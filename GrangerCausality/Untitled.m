%% VAR with channel's K nearest neigbors

DIAMETER_TO_PAIR_WITH = 1;
LAG = 3;

channels_per_model = (2 * DIAMETER_TO_PAIR_WITH) + 1;
base_model = varm(channels_per_model, LAG);

var_models = cell(size(windowed_eeg, 1) - (channels_per_model - 1),size(windowed_eeg,2));
model_count = 0;yy

for center_channel = DIAMETER_TO_PAIR_WITH + 1 : size(windowed_eeg, 1) - (DIAMETER_TO_PAIR_WITH + 1)
    model_count = model_count + 1;
    for window = 1:size(windowed_eeg,2)
        channel_range = center_channel - DIAMETER_TO_PAIR_WITH: center_channel + DIAMETER_TO_PAIR_WITH;
        var_models{model_count, window} = estimate(base_model, reshape(windowed_eeg(channel_range, window, :), [size(windowed_eeg, 3),channels_per_model]));
    end
end

%%
numpaths = 1001;
numobs = 1000;
rng(1); % For reproducibility
[Y,E] = simulate(var_models{1,1},numobs,'NumPaths',numpaths);