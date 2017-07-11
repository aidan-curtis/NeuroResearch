%% 2017 code
channel = mod(channel + 1,107)
subplot(2,2,1)
plot(reshape(mean(arti_sorted_stim_trial_data(channel,:,:)),[5000,1]));
subplot(2,2,2)
heatmap(reshape(arti_sorted_stim_trial_data(channel,:,:),[247,5000]), 'colormap', colormap('jet'), 'GridVisible', 'off');
subplot(2,2,3)
plot(reshape(mean(arti_sorted_arti_trial_data(channel,:,:)),[5000,1]));
subplot(2,2,4)
heatmap(reshape(arti_sorted_arti_trial_data(channel,:,:),[247,5000]), 'colormap', colormap('jet'), 'GridVisible', 'off');
%% 2012 code  -- cycle through artis
count = mod(count + 1, size(stim_aligned_ch, 2));
channel = stim_aligned_ch(count)
%channel = count
subplot(2,2,1)
plot(reshape(mean(arti_sorted_stim_trial_data(channel,:,:)),[5000,1]));
title(channel);
subplot(2,2,2)
imagesc(reshape(arti_sorted_stim_trial_data(channel,:,:),[247,5000]));
subplot(2,2,3)
plot(reshape(mean(arti_sorted_arti_trial_data(channel,:,:)),[5000,1]));
subplot(2,2,4)
imagesc(reshape(arti_sorted_arti_trial_data(channel,:,:),[247,5000]));

%% 2012 code -- cycle through stims
count = mod(count + 1, size(arti_aligned_ch, 2));
channel = arti_aligned_ch(count)
%channel = count
subplot(2,2,1)
plot(reshape(mean(arti_sorted_stim_trial_data(channel,:,:)),[5000,1]));
title(channel);
subplot(2,2,2)
imagesc(reshape(arti_sorted_stim_trial_data(channel,:,:),[247,5000]));
subplot(2,2,3)
plot(reshape(mean(arti_sorted_arti_trial_data(channel,:,:)),[5000,1]));
subplot(2,2,4)
imagesc(reshape(arti_sorted_arti_trial_data(channel,:,:),[247,5000]));