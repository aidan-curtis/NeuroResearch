coherency_matrix = zeros(size(data.eeg,1), size(data.eeg,1), 20);
count = 0;
window_size = 1000;
temporal_size = 10;
start_time = data.pulse_on(6);
end_time = data.pulse_on(7);
t = 0

for window_start = [start_time:temporal_size:end_time]
    t = t+1
    count = 0;
    for i = 1:size(data.eeg,1)
        for j = i:size(data.eeg,1)
            msc = mscohere(data.eeg(i, window_start:window_start+window_size),data.eeg(j, window_start:window_start+window_size),257, 129, [0:50], 1000);
            msc_mean = mean(msc(:));
            coherency_matrix(i, j, t) = msc_mean;
            coherency_matrix(j, i, t) = msc_mean;
        end
        fprintf('.')
        count = count + 1;
        if(count == 10)
            count = 0;
            fprintf('\n')
        end
    end  
end



%% getting graph

% A = coherency_matrix
% B = A < 0.1;   % sparsify A -- only values less than 0.2 are nonzeros in B
% p = symrcm(B); % compute reordering by Reverse Cuthill-McKee
% surf(A(p, p))

% 
% new_matrix = zeros(size(data.eeg,1), size(data.eeg,1));
% g = graph(coherency_matrix);
% for i = 1:size(coherency_matrix,1)
%     for j = 1:size(coherency_matrix,1)
%         if(coherency_matrix(i,j)>0.12 )
%             new_matrix(i,j) = 1;
%         end
%     end
% end

for image_num = [1:401]
    imagesc(coherency_matrix(:,:,image_num));
    images(image_num) = getframe;
end

%% Filter
clear coh_filtered
    moving_average = ones(1, 10)/10;
    for i = 1:size(data.eeg,1)
        for j = 1:size(data.eeg,1)
            
            coh_filtered(i, j, :) = filter(moving_average, 1, coherency_matrix(i, j, :));
            if(i == j)
                coh_filtered(i, j, :) = coh_filtered(i, j, :)-coh_filtered(i, j, :);
            else

            end
        end
    end
    
    
%% create filtered movie

for image_num = [1:401]
    imagesc(coh_filtered(:,:,image_num));
    images(image_num) = getframe;
end

%% Show movie
% filename = './../NeuroData/ta505_datasets/ta505_common.wav';
% [y, Fs] = audioread(filename);
% sound(y(8000*(60+2.5):8000*(85-2.5)), Fs)

movie(images, 20, 20)

%% Play sound



%% calculate centrality
for i = 1:size(coherency_matrix,1)
    for j = 1:size(coherency_matrix,2)
        importance_vector(findedge(g, i, j)) = coherency_matrix(i,j);
    end
end

c = centrality(g, 'eigenvector', 'importance', importance_vector)




%% Animating coherence of one pair
clear images
i = 10;
j = 12;
ii = 10;
jj = 58;
start_time = 60000;
end_time = start_time+30000;
window_size = 2000;
temporal_size = 50;
image_num = 0;
coht = []
coht_u = []
for window_start = [start_time:temporal_size:end_time]
    image_num = image_num+1;
    [cxy,w] = mscohere(data.eeg(i, window_start:window_start+window_size),data.eeg(j, window_start:window_start+window_size),257, 129, [0:30], 1000);
     [cxy2,w2] = mscohere(data.eeg(ii, window_start:window_start+window_size),data.eeg(jj, window_start:window_start+window_size),257, 129, [0:30], 1000);
    coht = [coht, mean(cxy)];
    coht_u = [coht_u, mean(cxy2)];
%     [cxy,w] = mscohere(data.eeg(i, 1:end),data.eeg(j, 1:end),2048, 1024, [0:300], 1000);
%      [cxy2,w2] = mscohere(data.eeg(ii, 1:end),data.eeg(jj, 1:end),2048, 1024, [0:300], 1000);
%     hold off
%      plot(w, cxy)
%     hold on
%     plot(w2, cxy2)
%     images(image_num) = getframe;
end

moving_average = ones(1, 10)/10;
coht_filtered = filter(moving_average, 1, coht)
coht_filtered_u = filter(moving_average, 1, coht_u)

hold off
plot(coht_filtered)
hold on
plot(coht_filtered_u)

%% Play movie

movie( images,1, 20)



%% Average Coherence Over entire intervals
t = 0
full_coherency_matrix = zeros(size(data.eeg,1), size(data.eeg,1), size(data.use_trials,1)-1);
for trial = data.use_trials(11)'
    
    t = t+1
    if(t ~=  size(data.use_trials,1))
    count = 0;
    for i = 1:size(data.eeg,1)
        for j = i:size(data.eeg,1)
            msc = mscohere(data.eeg(i, data.pulse_on(trial):data.pulse_on(trial+1)),data.eeg(j, data.pulse_on(trial):data.pulse_on(trial+1)),256, 128, [0:50], 1000);
            msc_mean = mean(msc(:));
            full_coherency_matrix(i, j, t) = msc_mean;
            full_coherency_matrix(j, i, t) = msc_mean;
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

%% Visualize total coherence


