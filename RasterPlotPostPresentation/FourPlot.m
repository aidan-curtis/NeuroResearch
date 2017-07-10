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
%% 2012 code
channel = mod(channel + 1,107)
subplot(2,2,1)
plot(reshape(mean(arti_sorted_stim_trial_data(channel,:,:)),[5000,1]));
subplot(2,2,2)
imagesc(reshape(arti_sorted_stim_trial_data(channel,:,:),[247,5000]));
subplot(2,2,3)
plot(reshape(mean(arti_sorted_arti_trial_data(channel,:,:)),[5000,1]));
subplot(2,2,4)
imagesc(reshape(arti_sorted_arti_trial_data(channel,:,:),[247,5000]));