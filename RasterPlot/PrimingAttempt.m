
%% scrambled segmentation

trial_data_scrambled = [];
trial_data_unscrambled = [];
use_scrambled = data.scramble(data.use_trials);
for trial = 1 : size(data.scramble(data.use_trials), 1)
    if(use_scrambled(trial))
        trial_data_scrambled(:, size(trial_data_scrambled,2)+1, :) = trial_data(:,trial,:);
    else
        trial_data_unscrambled(:, size(trial_data_unscrambled,2)+1, :) = trial_data(:,trial,:);
    end
end

%% Creating the fids
for trial_num = 1:247

for a = [1:107]
    meaning = mean((trial_data_scrambled(:,trial_num,:)).^2,2);
    data2 = reshape(meaning(a, : ,:), [5000,1]);
    windowSize = 100;
    filt = ones(1,windowSize)/windowSize;
    fid(a, :) = sqrt(sqrt(abs(filter(filt,1,data2'))));
end

for a = [1:107]
   maxmax(a) = max(fid(a, 100:end));
end

maxmaxmax = max(maxmax);



lo = []
of = []
lf = []
for a = [1:107]
   mid = (fid(a, 100:end)-mean(fid(a, 100:end), 2));
   temp = (mid);
   fid2(a, :) = round(temp);
   if(a==46 || a==47 || a==55 || a==56)
        lf = [lf temp'];
   end
   if(a<=100 && a>=93)
        lo = [lo temp'];
   end
   if(a<=76 && a>=61)
        of = [of temp'];
   end
end


    hold off;
    st = 1
    meanlo = mean([lo(st:end, 4:end) lt(st:end, 8:9)], 2)
    meanof = mean(of(st:end, :), 2)
    plot([meanlo meanof])

    images(trial_num) = getframe
end
