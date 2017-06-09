WINDOW_LENGTH = 2048;
MS_BETWEEN_WINDOWS = 1024;

number_of_windows = floor((size(data.filtered, 2) - WINDOW_LENGTH)/MS_BETWEEN_WINDOWS);


for channel = 1:size(data.filtered, 1)
    for window = 1:number_of_windows
        window_start = ((window - 1) * MS_BETWEEN_WINDOWS)+1;
        data.windows(channel, window, :) = data.filtered( channel, window_start: window_start + WINDOW_LENGTH); 
    end
end