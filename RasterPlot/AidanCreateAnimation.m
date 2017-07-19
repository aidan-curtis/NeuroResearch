
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

for a = [1:107]
    meaning = mean((trial_data).^2,2);
    data2 = reshape(meaning(a, : ,:), [5000,1]);
    windowSize = 100;
    filt = ones(1,windowSize)/windowSize;
    fid(a, :) = sqrt(sqrt(abs(filter(filt,1,data2'))));
end


%% Finding the maximum maximum

for a = [1:107]
   maxmax(a) = max(fid(a, 100:end));
end

maxmaxmax = max(maxmax);

%% Normalized the the maximum maximum

lo = []
of = []
lt = []
lf = []
for a = [1:107]
   mid = (fid(a, 100:end)-mean(fid(a, 100:end), 2));
   temp = 31*(mid./(max(abs(mid))));
   fid2(a, :) = round(temp);
   if(a==45 || a==46 || a==47 || a==55 || a==56)
        lf = [lf temp'];
   end
   if(a<=37 && a>=1)
        lt = [lt temp'];
   end
   if(a<=100 && a>=93)
        lo = [lo temp'];
   end
   if(a<=76 && a>=61)
        of = [of temp'];
   end
end

%% Plotting occ vs frontal
hold off;
st = 1
meanlo = mean([lo(st:end, 4:end) lt(st:end, 8:9)], 2)
meanof = mean(of(st:end, :), 2)
meanlf = mean(lf(st:end, :), 2)
plot([meanlo meanof, meanlf])


%% colormap

for a = [1:64]
   colortrans(a, 1) = a/64 
end

%% Color map it

for a = 1:107
   for b = 1:4901
       round(fid2(a, b));
       thecolors(a,b, :) = colortrans(round(fid2(a, b)), :);
   end
end
 