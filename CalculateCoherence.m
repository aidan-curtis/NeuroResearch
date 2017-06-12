coherency_matrix = zeros(size(data.eeg,1), size(data.eeg,1), 20);
count = 0;
window_size = 2500;
temporal_size = 500;
start_time = 60000;
end_time = start_time+20000;
t = 0
for window_start = [start_time:temporal_size:end_time]
    t = t+1
    count = 0;
    for i = 1:size(data.eeg,1)
        for j = i:size(data.eeg,1)
            msc = mscohere(data.eeg(i, window_start:window_start+window_size),data.eeg(j, window_start:window_start+window_size),257, 129, [70:300]);
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

for image_num = [1:41]
    imagesc(coherency_matrix(:,:,image_num));
    images(image_num) = getframe;
end

%% Show movie
filename = './../NeuroData/ta505_datasets/ta505_common.wav';
[y, Fs] = audioread(filename);
% sound(y(8000*(60+2.5):8000*(85-2.5)), Fs)

    movie( images,1, 2)



%% Play sound



%% calculate centrality
for i = 1:size(coherency_matrix,1)
    for j = 1:size(coherency_matrix,2)
        importance_vector(findedge(g, i, j)) = coherency_matrix(i,j);
    end
end

c = centrality(g, 'eigenvector', 'importance', importance_vector)




