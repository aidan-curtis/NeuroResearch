%% T test
%pairs

%list of trials for either case
indecies_case_a = find(data.use_scramble); 
indecies_case_b = find(~data.use_scramble);
%array (trials, channels), containing feature vector for the specified unit
one_dim_feature_vector_array = data.E;

t_vals = zeros(size(one_dim_feature_vector_array, 2), 1);

size_case_b = size(indecies_case_b, 2);
size_case_a = size(indecies_case_a, 2);
groups_size = size_case_a*size_case_b;

for channel = [1:size(one_dim_feature_vector_array, 2)]
   groups = zeros(1, groups_size);
   %groups is a list of the differences in power between any possible pair of
   %case b vs case a trials in each channel
   current = 0;
   for i = indecies_case_a
       for j = indecies_case_b
           current = current + 1;
           groups(1, current) = abs(one_dim_feature_vector_array(i, channel)- one_dim_feature_vector_array(j, channel));
       end
   end
   clearvars i j current;
   
   %calculate pair difference variance and mean
   mean_val = mean(groups(:));
   standard_deviation = std(groups(:));
   t_val = mean_val/(standard_deviation/sqrt(groups_size));
   t_vals(channel) = t_val;

end

disp(t_vals);

clearvars mean_val standard_deviation groups t_val;
clearvars power_vector_array indecies_scrambled indecies_not_scrambled;
clearvars group_size size_scr size_not_scr;
%% choose top n channels

%CHANGE ME
channels_to_choose = 100;

[value, index] = sort(t_vals(:), 'descend');
best_channels = index(1:channels_to_choose);

data.good_channels = best_channels;



