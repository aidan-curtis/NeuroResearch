%% T test
%pairs

%list of trials in which the image is either scrambled or not scrambled
indecies_scrambled = find(data.use_scramble); 
indecies_not_scrambled = find(~data.use_scramble);
%array (trials, channels), containing power vector for the specified unit
power_vector_array = data.E;

t_vals = zeros(size(power_vector_array, 2), 1);

size_not_scr = size(indecies_not_scrambled, 2);
size_scr = size(indecies_scrambled, 2);
groups_size = size_scr*size_not_scr;

for channel = [1:size(power_vector_array, 2)]
   groups = zeros(1, groups_size);
   %groups is a list of the differences in power between any possible pair of
   %scrambled vs non scrambles trials in each channel
   current = 0;
   for i = indecies_scrambled
       for j = indecies_not_scrambled
           current = current + 1;
           groups(1, current) = abs(power_vector_array(i, channel)- power_vector_array(j, channel));
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
channels_to_choose = 20;

[value, index] = sort(t_vals(:), 'descend');
best_channels = index(1:channels_to_choose);

data.good_channels = best_channels;


