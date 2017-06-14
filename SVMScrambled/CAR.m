for time = 1:size(data.eeg, 2)
    mean_car(time) = mean(data.eeg(:, time));
end


for channel = 1:size(data.eeg, 1)
    data.car(channel, :) = data.eeg(channel, :)-mean_car(:)';
end

plot(mean_car)