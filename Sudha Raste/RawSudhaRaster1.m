% for plotting
load('ta505_common_fil.mat');
%load bad channel data
load('ta505_bad_channels.mat');
use_trials = find(data.accuracy(:).*data.tech(:).*data.noise(:));
use_times = data.pulse_on(use_trials);
data.articulation = data.articulation(use_trials);
data.pulse_on = data.pulse_on(use_trials);
data.eeg = data.eeg(bad_channels.common,:);
data.ch_names = data.ch_names(bad_channels.common,:);
data.scramble = data.scramble(use_trials);
nch = size(data.eeg,1);
ntrials = size(use_trials,1);
% plotting with correct time stamps
load('Power_time_mean.mat');
load('Power_ch_trials_time.mat');
T1 = (0:4864-256-1) + 128;
T2 = (-2000:1743)+ 128;
art = data.articulation - data.pulse_on;
%art(206) = [];
[val, ind] = sort(art);
for i=1:50
    scrsz = get(0,'ScreenSize');
    print('Channel %d',i);
    figure('Position',[1 scrsz(4) scrsz(3)/1.2 scrsz(4)/1.2])
    subplot(2,2,1);
    plot(T1(1:3000),Power_time_mean.timestamp_1m(i,(1:3000)));
    ylim([0, max(Power_time_mean.timestamp_1m(i,(1:3000)))]);
    [maxvalue,maxind] = max(Power_time_mean.timestamp_1m(i,(1:3000)));
    txt1 = sprintf('(%d,%0.1f)',T1(maxind), maxvalue);
    text(T1(maxind),maxvalue,txt1,'Position',[T1(maxind),maxvalue/10])
    str = sprintf('Channel %d aligned to stimulus onset',i);
    title(str);
    subplot(2,2,3);
    plot(T2,Power_time_mean.timestamp_2m(i,:));
    ylim([0, max(Power_time_mean.timestamp_2m(i,:))]);
    [maxvalue,maxind] = max(Power_time_mean.timestamp_2m(i,:));
    txt2 = sprintf('(%d,%0.1f)',T2(maxind), maxvalue);
    text(T2(maxind),maxvalue,txt2,'Position',[T2(maxind),maxvalue/10])
    str = sprintf('Channel %d aligned to articulation',i);
    title(str);
    subplot(2,2,2);
    stim_alig_matrix = reshape(Power_ch_trials_time.highGammaBand(i,:,:),ntrials, length(T1));
    stim_alig_matrix = stim_alig_matrix(ind,:);
    imagesc(T1(1:3000),1:nch,stim_alig_matrix(:,1:3000));
    str = sprintf('Stimulus aligned high gamma power data for ch %d',i);
    title(str);
    colorbar;
    subplot(2,2,4);
    art_alig_matrix = reshape(Power_ch_trials_time.highGammaBandAlign(i,:,:),ntrials, length(T2));
    art_alig_matrix = art_alig_matrix(ind,:);
    imagesc(T2,1:nch,art_alig_matrix(:,:));
    str = sprintf('Articulation aligned high gamma power data for ch %d',i);
    title(str);
    colorbar;
end