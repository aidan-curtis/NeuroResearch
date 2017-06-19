for channel = sorted_CL_indices'
    %h = image(reshape(trial_z_score(100,:,:),[size(trial_z_score,2) TRIAL_LENGTH]), 'CDataMapping', 'scaled')
    %colorbar
    colormap('jet')
    %h = heatmap(reshape(trial_z_score(channel, :, :), [size(trial_z_score,2) TRIAL_LENGTH]), 'colormap', colormap('parula'), 'GridVisible', 'off')
    frames(channel) = imagesc(reshape(trial_z_score(100,:,:),[size(trial_z_score,2) TRIAL_LENGTH]));
    %frames(channel) = getframe(gcf()); 
    %frames(channel) = getframe();
end
%movie(frames)
implay(frames);