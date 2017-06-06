%% Get power of the signal at different frequencies

centers = [70, 73.0, 79.5, 87.8, 96.9, 107.0, 118.1, 130.4, 144.0]
sizes = []
[~, sc] = size(centers);

for a = [2: sc]
    sizes(a-1) = centers(a)-centers(a-1)
end

%% Make filters for spectrums


interval = data.eeg(1, 1100:2100);

[~, N] = size(interval)


%LENGTH MUST BE 100, OTHERWISE, YOU MUST CHANGE 70 and 170
b = fir1(580,[70/N, 170/N]);
H = freqz(b,1, N);


filtered = filter(b, 1, interval)

plot(filtered)




% % plot(interval)
% for channel = [1: 2]
%         
%         
%     
% %     for center = centers
%         center = 1;
% 
%         bottom = centers(center)-sizes(center)/2;
%         top = centers(center)+size(center)/2;
% 
%         [~, N] = size(interval);
%         
% 
% %     end
%     
% end
