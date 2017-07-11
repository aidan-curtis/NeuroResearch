
clear
run('LoadData.m');
target_data = data.eeg;

%%
HIGH_GAMMA_LOWER = 70;
HIGH_GAMMA_UPPER = 150;
FILTER_HI_GAMMA = true;
if FILTER_HI_GAMMA
    run('FilterHiGamma.m');
    target_data = filtered_eeg;
else
    target_data = data.eeg;
end
%%
WINDOW_LENGTH = 200;
CONVERT_TO_POWER = true;
if CONVERT_TO_POWER
    run('Power.m');
    target_data = power_data;
else
    target_data = target_data;
end

%%
TRIAL_LENGTH = 5000
STIM_TRIAL_DELAY = 2000;
ARTI_TRIAL_RETRO = 1500; % Must be less than TRIAL_LENGTH
run ('SplitIntoTrials.m');
target_stim_trial_data = arti_sorted_stim_trial_data; %Stimulation + TRIAL_TIME
target_arti_trial_data = arti_sorted_arti_trial_data; % TRIAL_TIME surrounding articulation

%%
CONVERT_TO_Z_SCORES = false;
if CONVERT_TO_Z_SCORES
    run('ZScores.m');
    target_trial_data = trial_z_score;
else
end

%%
target_ave_arti_trial_data = reshape(mean(target_arti_trial_data(:,:,:),2), [107,5000]);
target_ave_stim_trial_data = reshape(mean(target_stim_trial_data(:,:,:),2), [107,5000]);