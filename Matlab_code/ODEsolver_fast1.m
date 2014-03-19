function C = ODEsolver_fast1(spike_tr,len,param)

% Euler method
dt = 1/param.Fs;

spikes = zeros(param.num_levels,param.n_channels,len);
for i = 1:param.n_channels
    for j = 1:param.num_levels
        spikes(j,i,spike_tr{i}{j}) = 1;
    end
end

M = 1*ones(param.num_levels,param.n_channels);
C = zeros(param.num_levels,param.n_channels,len);
R = zeros(param.num_levels,param.n_channels);

for i = 2:len
    C(:,:,i) = C(:,:,i-1) + dt*(spikes(:,:,i).*M - param.alpha.*C(:,:,i-1));
    M = M + dt*(param.beta.*R - spikes(:,:,i).*M);
    R = R + dt*(param.alpha.*C(:,:,i-1) - param.beta.*R);
end
