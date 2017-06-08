centers = [70, 73.0, 79.5, 87.8, 96.9, 107.0, 118.1, 130.4, 144.0]
% for trial_val = transpose(data.use_trials)
hold off;

[pxx,f] = periodogram(data.filtered(7,:));
plot(f,10*log10(pxx));
hold on;
plot(f,10*log10(pxx))
   %     plot(abs(fft(data.filtered(channel, :))))
%     end
