function plot_AN_4level(AN,level,param,len_input)

mat = zeros(param.n_channels,len_input);

for i = 1:param.n_channels
    mat(i,AN{i}{level}) = 1;
end

[A,B] = find(mat);
Bt = B/param.Fs;
scatter(Bt,A,'x');
axis([0 len_input/param.Fs 0 param.n_channels])
xlabel('Time (s)')
ylabel('Filter channel')
title(['AN spikes for level ',num2str(level)])