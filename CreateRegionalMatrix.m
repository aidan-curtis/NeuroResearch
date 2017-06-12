%% mean over time
region_index = 0;
for regional_cell = regional_coherence
    region_index=region_index+1;
    a(region_index,:) = reshape(mean(mean(cell2mat(regional_cell))), 1, 41)
end
a = reshape(a, 9, 41)

plot(a')
title('Coherency difference by region')
legend(region_name)
ylabel('Coherency Difference')
xlabel('Time window #')

