function [onset,V] = LIFneuron(Cadj,leak,param)
% This function returns the onset spikes for a given channel and
% sensitivity level.
%
% Inputs:
% Cadj: matrix containing C(t) (qty. of neurotransmitter being used) of the
% current and adjacent channels. The rows are the C(t) for a given channel,
% so it has param.adj_ch*2 + 1 rows. The central row corresponds to the
% central channel.
% 
% leak = leakage factor used in the V(t) differential equation

len = size(Cadj,2);
% Innervation of the onset neuron
I = 0;
for i = 1:size(Cadj,1)
    I = I + (param.w/size(Cadj,1)) * Cadj(i,:);
end

% Voltage of the neuron
It = linspace(1/param.Fs,len/param.Fs,len);
ic = 0;
[~,V] = ode45(@(t,v) voltage(t,v,It,I),It,ic);
% figure,plot(It,V)
% figure,plot(It,I)

sp = find(V>=param.threshold,1,'first');
onset = [];

while (~isempty(sp))
    V(sp:end) = V(sp:end)-V(sp);
    refr_samp = round(param.Fs*param.refrac_time);
    V(sp:min(length(V),sp+refr_samp)) = 0;
    V(sp+refr_samp+1:end) = V(sp+refr_samp+1:end)...
        -V(min(length(V),sp+refr_samp+1));
    onset = [onset sp];
    sp = find(V>=param.threshold,1,'first');
end

    function dv = voltage(t,v,t_int,intensity)
        intensity = interp1(t_int,intensity,t);
        dv = -v/leak + intensity;
    end

end
