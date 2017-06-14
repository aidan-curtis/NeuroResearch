WINDOW_SIZE = 200;
WINDOW_START_DELAY = 100;
SECTION_TO_WINDOW = [60 * 1000, 2 * 60 * 1000];
%SECTION_TO_WINDOW = [1, size(data.eeg, 2)];
number_of_windows = floor(((SECTION_TO_WINDOW(2)-(WINDOW_SIZE - WINDOW_START_DELAY)) - SECTION_TO_WINDOW(1))/WINDOW_START_DELAY);

windowed_eeg = zeros(size(data.eeg,1), number_of_windows, WINDOW_SIZE);

for window = 1:number_of_windows
    for channel = 1:size(data.eeg,1)
        window_start_time = (window - 1) * WINDOW_START_DELAY + SECTION_TO_WINDOW(1);
        windowed_eeg(channel, window, :) = data.eeg(channel, window_start_time : (window_start_time + WINDOW_SIZE)-1);
    end
end
