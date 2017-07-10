important = [1:size(data.eeg, 1)]
coherence_matrix = zeros(size(important,2), size(important,2), 20);
start_time = data.pulse_on(6);
end_time = data.pulse_on(7);
t = 0
for trial = data.use_trials(1:20)'
    t = t+1
    count = 0;
    for i = 1:size(important, 2)
        for j = 1:size(important, 2)
            msc = mscohere(trial_data(important(i), :, trial),trial_data(important(j), :, trial),512, 256,[70, 170], 1000);
            msc_mean = mean(msc(:));
            coherence_matrix(i, j, t) = msc_mean;
            coherence_matrix(j, i, t) = msc_mean;
        end
        fprintf('.')
        count = count + 1;
        if(count == 10)
            count = 0;
            fprintf('\n')
        end
    end  
end