function spike_train = pg_zerocross(signal)
% This function returns the indexes of the positive-going zero-crossing
% points of the input signal.

s = sign(signal);
s(s==0) = 1;
ds = diff(s);
ds = [0 ds]; % diff returns n-1 samples, so we add a 0 in the beginning
% (no spikes can occur in the first sample).
spike_train = find(ds>0);
