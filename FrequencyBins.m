%% Get power of the signal at different frequencies

centers_false = [70, 73.0, 79.5, 87.8, 96.9, 107.0, 118.1, 130.4, 144.0]
sizes = []
[~, sc] = size(centers_false);

for a = [2: sc]
    centers(a-1) = centers_false(a)
    sizes(a-1) = centers_false(a)-centers_false(a-1)
end

%% Make filters for spectrums
bin_window_start = 1
bin_window_size = 100

for channel = [2: 2] 
     for center_f = [1:size(centers,2)]
         
        bottom = centers(center_f) - sizes(center_f)/2;
        top = centers(center_f) + sizes(center_f)/2;
        
        b = fir1(5000, [bottom*2/fs, top*2/fs]);
        temp = filter(b, 1, filtered(channel, bin_window_start:bin_window_start+bin_window_size))
        V(channel, 1, center_f, :) = temp
        plot(temp)
        hold on;
        plot(abs(hilbert(temp)))
        
     end    
end


