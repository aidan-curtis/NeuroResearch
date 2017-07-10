

b = (1/WINDOW_LENGTH)*ones(1,WINDOW_LENGTH);
a = 1;

power_data = zeros(size(target_data));

for channel=1:size(target_data,1)
    power_data(channel, :) = filter(b,a,target_data(channel,:) .^2 );
    fprintf('channel %i filtered \n', channel);
end
    