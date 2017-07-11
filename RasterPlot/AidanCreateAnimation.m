filter_length = 100.0
fir = (ones(1,filter_length)/filter_length)
series = reshape(mean(trial_z_score(1, :, :), 2), [1, 5000])
filtered = filter(fir,1 ,series)
plot(filtered)
