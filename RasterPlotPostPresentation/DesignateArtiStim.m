arti_aligned_ch = [];
arti_aligned_ch_logic = zeros(size(target_ave_arti_trial_data, 1));
stim_aligned_ch = [];
stim_aligned_ch_logic = zeros(size(target_ave_arti_trial_data, 1));

for channel=1:size(target_ave_arti_trial_data)
    display(max(target_ave_arti_trial_data(channel, :)));
    display(max(target_ave_stim_trial_data(channel, :)));
    display('=========================');
    if max(target_ave_arti_trial_data(channel,:)) > 20 + max(target_ave_stim_trial_data(channel,:))
        arti_aligned_ch(end+1) = channel;
        arti_aligned_ch_logic(channel) = true;
    elseif max(target_ave_arti_trial_data(channel,:)) + 20 < max(target_ave_stim_trial_data(channel,:))
        stim_aligned_ch(end+1) = channel;
        stim_aligned_ch_logic(channel) = true;
    end
end