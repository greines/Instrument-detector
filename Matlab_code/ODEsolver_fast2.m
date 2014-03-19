function C = ODEsolver_fast2(spike_tr,len,param)

% Euler method
dt = 1/param.Fs;

%C contains the positions of the spikes firstly, and it will be overwritten
%by the actual values of C in each iteration
C = zeros(param.num_levels,param.n_channels,len);
for i = 1:param.n_channels
    for j = 1:param.num_levels
        C(j,i,spike_tr{i}{j}) = 1;
    end
end

M = 1*ones(param.num_levels,param.n_channels);
C(:,:,1) = 0;
R = zeros(param.num_levels,param.n_channels);

for i = 2:len
    spikes = C(:,:,i);
    C(:,:,i) = max(C(:,:,i-1) + dt*(param.gamma*spikes.*M - param.alpha.*C(:,:,i-1)),0);
    M = max(M + dt*(param.beta.*R - param.gamma*spikes.*M),0);
    R = max(R + dt*(param.alpha.*C(:,:,i-1) - param.beta.*R),0);
end
