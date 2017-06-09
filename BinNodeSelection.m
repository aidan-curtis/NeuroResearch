%% Combine bins into one_dim_feature_vector_array
one_dim_feature_vector_array = []
for channel = [1: size(F, 1)]
    for bin = [1:size(F,3)]
        one_dim_feature_vector_array = [one_dim_feature_vector_array F(channel, :, bin)'];  
        size(one_dim_feature_vector_array)
    end
end
data.frequency_channels = one_dim_feature_vector_array;
%% T test
%pairs

%list of trials for either case
indecies_case_a = repelem(find(data.use_scramble), 8); 
indecies_case_b = repelem(find(~data.use_scramble), 8);

%array (trials, channels), containing feature vector for the specified unit


t_vals = zeros(size(one_dim_feature_vector_array, 2), 1);

size_case_b = size(indecies_case_b, 2);
size_case_a = size(indecies_case_a, 2);
groups_size = size_case_a*size_case_b;



for channel = [1:size(one_dim_feature_vector_array, 2)]
   groups = zeros(groups_size, 1);
   %groups is a list of the differences in power between any possible pair of
   %case b vs case a trials in each channel
   current = 0;
   differences = [];
   for i = indecies_case_a
       for j = indecies_case_b
           current = current + 1;
           groups(current) = one_dim_feature_vector_array(i, channel) - one_dim_feature_vector_array(j, channel);
       end
   end
   clearvars i j current;
   
   %calculate pair difference variance and mean
   mean_val = mean(groups(:));
   standard_deviation = std(groups(:));
   t_val = mean_val/(standard_deviation/sqrt(groups_size));
   t_vals(channel) = abs(t_val);
   
   if(ismember(channel, data.good_channels))
       figure;
        hist(groups(:),100)
   end
end

disp(t_vals);

clearvars mean_val standard_deviation t_val;
clearvars power_vector_array indecies_scrambled indecies_not_scrambled;
clearvars group_size size_scr size_not_scr;
%% choose top n channels

%CHANGE ME
channels_to_choose = 2;


[value, index] = sort(t_vals(:), 'descend');
best_channels = index(1:channels_to_choose);



data.good_channels = best_channels;



