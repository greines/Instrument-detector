function param = parameter_setup()

param = [];
param.Fs = 44100;%%%%%%%
param.num_levels = 10;
param.order = 2; %used only in Holdsworth filtering method
% Filterbank parameters:
param.f_low = 200;
param.f_high = 5000;
param.n_channels = 10;
param.cf = MakeErbCFs(param.f_low,param.f_high,param.n_channels);
% param.cf = [120 400 880 1740 3250 6000]; %central frequencies
% param.cf = [120 200 290 400 530 ...
%     690 880 1100 1400 1740 ...
%     2150 2650 3250 4000 4900]; %central frequencies
% param.cf = [90 120 160 200 240 290 340 400 460 530 ...
%     600 690 780 880 1000 1100 1250 1400 1560 1740 ...
%     1930 2150 2400 2650 3000 3250 3600 4000 4410 4900];

% The correction factor is used for adjusting the implementation of Michael
% Newton and this one. It is calculated as the average of the quotient
% between the maximum of this toolbox's IR (for each channel) and the maximum
% of M. Newton's toolbox's IR.
% param.corr_factors = [1.3740 1.3578 1.3408 1.3520 1.3471 1.3277 1.3253...
%     1.3177 1.3060 1.2916];
% param.min_levels = 0.0002*param.corr_factors;
param.correction_factor = 1.334;
param.min_level = 0.0006*param.correction_factor; %0.0002

% ODE parameters
param.alpha = 1100; %100
param.beta = 9; %9
param.gamma = 100; %1100
param.gamma = param.gamma*param.Fs/1000;

% LIF neuron parameters
param.adj_ch = 1; %number of adjacent channels for each side
param.w = 5000; %weight of the synapse group (central channel plus 2*adj_ch).
% w is divided equally among all the channels. For example, if n_adj = 1,
% we have 3 channels in the synapse group. So the weights would be 1/3 for
% each single synapse.
param.threshold = 1; %firing threshold (V) def:0.0001
param.refrac_time = 0.02; %refractory time (in seconds) after firing

% Onset fingerprint
param.win_len = 0.001; %window length (in seconds) for onset fingerprint
param.len_ofp = 100; %length in samples of the truncated onset fingerprint
