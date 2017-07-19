fs = 1000

% for channel = [1:107]
channel = 107
id = 1
for a = data.use_trials(:)'
    figure
     cwt(data.eeg(channel, data.pulse_on(a)-2500:data.pulse_on(a)+2500), fs);
    id = id+1
end
figure
wscalogram('image',reshape(mean(wt, 1), [94, 5001]));
% end



