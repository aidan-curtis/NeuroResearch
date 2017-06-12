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
TIME_SIZE = 500;
START_TIME = 60000;
END_TIME = START_TIME+20000;

for region = regions'
    
    
    region_index = region_index+1;
    fprintf('\n')
    fprintf('Calculating coherency for %s', region_name{region_index})
  
    region_size = region(2)-region(1)+1;
    coh = zeros(region_size, region_size, 20);
    count = 0;
    t = 0;
    for window_start = START_TIME:TIME_SIZE:END_TIME
        fprintf('\n');
        t = t+1
        count = 0;
        for i = 1:region_size
            for j = i:region_size
                msc = mscohere(data.eeg(i, window_start:window_start+WINDOW_SIZE),data.eeg(j, window_start:window_start+WINDOW_SIZE),257, 129, [70:300]);
                msc_mean = mean(msc(:));
                coh(i, j, t) = msc_mean;
                coh(j, i, t) = msc_mean;
            end
            fprintf('.')
            count = count + 1;
            if(count == 10)
                count = 0;
                fprintf('\n')
            end
        end
        regional_coherence{region_index} = coh;
    end
end