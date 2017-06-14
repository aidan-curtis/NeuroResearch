%% only differences within a channel
ORDER_OF_DIFFERENCES_TO_CALC = 1;
for order = 1:ORDER_OF_DIFFERENCES_TO_CALC
    for channel = 1:size(windowed_eeg,1)
        for time = 1:size(windowed_eeg,3)
            if time > order + 1
                raw_auto_differences(order, channel, :, time) = windowed_eeg(channel,:,time) - windowed_eeg(channel,:,(time - order));
            else
                raw_auto_differences(order, channel, :, time) = windowed_eeg(channel,:,time);
            end
        end
    end
end

%% differences across channels (including within channels)
%channel_1 is the current channel
%channel_2 is the "causing" channel
ORDER_OF_DIFFERENCES_TO_CALC = 1;

raw_cross_differences = zeros(ORDER_OF_DIFFERENCES_TO_CALC, size(windowed_eeg,1),size(windowed_eeg,1),size(windowed_eeg,2),size(windowed_eeg,3));

for order = 1:ORDER_OF_DIFFERENCES_TO_CALC
    for channel_1 = 1:size(windowed_eeg,1)
        fprintf('---------ch1 --> %i---------\n', channel_1);
        for channel_2 = 1:size(windowed_eeg,1)
            fprintf('ch2 --> %i\n', channel_2);
            for time = 1:size(windowed_eeg,3)
                if time > order
                    raw_cross_differences(order, channel_1, channel_2, :, time) = windowed_eeg(channel_1,:,time) - windowed_eeg(channel_2,:,(time - order));
                else
                    raw_cross_differences(order, channel_1, channel_2, :, time) = windowed_eeg(channel_1,:,time);
                end
            end

        end
    end
end