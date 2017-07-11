important = [1:size(data.eeg, 1)]
coherence_matrix = zeros(size(important,2), size(important,2), 100,20);
start_time = data.pulse_on(6);
end_time = data.pulse_on(7);
t = 0
window_size = 1500
step_size = 50
trial_num = 0
for window_start = [1: step_size: 5000]
    t = t+1
    trial_num = 0
    for trial = data.use_trials(1:20)'
        trial_num = trial_num+1
        count = 0;
        for i = 1:size(important, 2)
            for j = 1:size(important, 2)
                msc = mscohere(trial_data(important(i), window_start:window_start+window_size, trial),trial_data(important(j), window_start:window_start+window_size, trial),512, 256,[70, 170], 1000);
                msc_mean = mean(msc(:));
                coherence_matrix(i, j, t, trial_num) = msc_mean;
                coherence_matrix(j, i, t, trial_num) = msc_mean;
            end
            fprintf('.')
            count = count + 1;
            if(count == 10)
                count = 0;
                fprintf('\n')
            end
        end  
    end
end


export_coh = mean(coherence_matrix, 4)
