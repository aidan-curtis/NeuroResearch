%% movie of the periodigram over time
clearvars images timer
TIME_WINDOW = 2000;
TIME_HOP = 50;
image_num = 0;

for time_start = 60000:TIME_HOP:200000
    image_num = image_num+1
    [pxx, y] = periodogram(data.car(107,time_start:time_start+TIME_WINDOW));
    timer(image_num) = mean(pxx);
end
%% plot timer
clearvars scrambled non_scrambled
index_scrambled = 0;
non_scrambled = [];
scrambled = [];
for a = [5:31]
    index_scrambled = index_scrambled + 1;
    if(data.scramble(a) == 1)
        non_scrambled = [non_scrambled floor((data.articulation(a)-60000)/TIME_HOP)]
    else
        scrambled = [scrambled floor((data.articulation(a)-60000)/TIME_HOP)]
    end
  
end


hold off;
plot(60000:TIME_HOP:200000,timer,'-o','MarkerIndices',non_scrambled, 'MarkerEdgeColor','blue')
hold on;
plot(60000:TIME_HOP:200000,timer,'-o','MarkerIndices',scrambled, 'MarkerEdgeColor','black')
%% PLAY
movie( images,1, 20)
