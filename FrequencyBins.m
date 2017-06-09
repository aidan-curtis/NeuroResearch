%% Get power of the signal at different frequencies

centers_false = [70, 73.0, 79.5, 87.8, 96.9, 107.0, 118.1, 130.4, 144.0]
sizes = []
[~, sc] = size(centers_false);

for a = [2: sc]
    centers(a-1) = centers_false(a)
    sizes(a-1) = centers_false(a)-centers_false(a-1)
end

%% Make filters for spectrums


trial_num = 0
for trial_val = transpose(data.use_trials)
    trial_num = trial_num+1;
    window_start = data.pulse_on(trial_val);
    window_end = data.articulation(trial_val);

    for channel = [1: size(data.eeg, 1)] 
     for center_f = [1:size(centers,2)]
        bottom = centers(center_f) - sizes(center_f)/2;
        top = centers(center_f) + sizes(center_f)/2;
        
        b = fir1(4000, [bottom*2/data.fs, top*2/data.fs]);
        temp = filter(b, 1, data.eeg(channel, window_start:window_end));
        
        log_power = 0;
        total = 0;
        for j = [1:size(temp, 2)];
            
            log_power = log_power + (temp(:,j))^2;
            total = total + 1;
        end
   
        F(channel, trial_num, center_f) = log_power/total;
     end
         fprintf('.');

    end
    fprintf('\n');
end


