src = [];
nsrc = [];
for channel = data.good_channels
      src = [src, sum(E(data.use_scramble, channel))]
      nsrc = [nsrc, sum(E(~data.use_scramble, channel))]
end

src = src/sum(data.use_scramble)
nsrc = nsrc/sum(~data.use_scramble)


hold off;
bar([src; nsrc]')
hold on;