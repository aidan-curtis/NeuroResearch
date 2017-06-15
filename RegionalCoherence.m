% Left Temporal : 1:37
% Left Frontal: 38:56
% Occipital Pole: 57:60
% Orbital Frontal 61:76
% Suboccipital 77:86
% Temporal Pole 87:88
% Medial Subtemporal 89:92
% Lateral Occipital 93:100
% Posterior Subtemporal 101:107

% This file has been deemed irrelevant

region_name = {'Left Temporal'; 'Left Frontal'; 'Occipital Pole'; 'Orbital Frontal'; 'Suboccipital'; 'Temporal Pole'; 'Medial Subtemporal'; 'Lateral Occipital'; 'Posterior Subtemporal'};
regions = [1,37;38,56;57,60;61,76;77,86;87,88;89,92;93,100;101,107];
region_index = 0;

WINDOW_SIZE = 2500;
TIME_SIZE = 50;
START_TIME = 60000;
END_TIME = START_TIME+20000;

for region = regions'
    
    
    region_index = region_index+1;
    fprintf('\n')
    fprintf('Calculating coherency for %s', region_name{region_index})
  
    region_size = region(2)-region(1)+1;
    regional_coherence(region_index, :) = zeros(size(coherency_matrix, 3),1);
    count = 0;
    t = 0;
    for time = [1:size(coherency_matrix, 3)]
        fprintf('\n');
        t = t+1;
        regional_coherence(region_index, time) = mean(mean(coh_filtered(region(1):region(2), region(1):region(2), time)));
    end  
end

hold off;
for region = 1:9
    plot(regional_coherence(region, :))
    hold on
end
legend(region_name)