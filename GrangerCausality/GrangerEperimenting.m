%% VAR with channel's K nearest neigbors


ORDER = 3;
channels_per_model = 2;
model_count = 0;
center_channel = 16;
t=0;
window_size = 150
G = zeros(1, 134)

for window = [60000:window_size:80000]
        t=t+1
        model_count = model_count + 1;
        random1 = data.eeg(center_channel, window:window+window_size, :);
        random2 = data.eeg(center_channel+1, window:window+window_size, :);
        [F(t), cv] = granger_cause(random1, random2, 1, 40);
        [G(t), cv] = granger_cause(random2, random1, 1, 40);
end

%% Granger causal Modeling
hold off;
plot(F)
hold on;
plot(G)
