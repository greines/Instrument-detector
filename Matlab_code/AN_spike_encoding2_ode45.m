function [AN,onset,filtered] = AN_spike_encoding2_ode45(input,param)
% This function computes the AN-like spike encoding of the input signal.
%
% The input values are:
% - input: sound signal we want to encode. TIP: use "input_setup.m" to
% easily select a wav file and adapt to the required format.
% - param: set of parameters for the encoding. Edit the "parameter_setup.m"
% script for changing them.
%
% The output values are:
% - AN: cell of n_filt which contains the spike locations (in
% samples) for each level of each filtered signal.
% - filtered: array with the filtered signals
tic

%% First step: 
% Filter the signal with the gammatone filterbank. Central
% frequencies of the filters are computed below:
cf = param.cf;

% Holdsworth implementation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtered = zeros(length(cf),length(input));
% for i = 1:length(cf)
%     filtered(i,:) = gammatone_filtering(input,cf(i),param);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Slaney implementation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcoefs = MakeERBFilters(param.Fs,cf,1);
filtered = ERBFilterBank(input,fcoefs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Second step:
% Detect the positive-going zero-crossing points in each
% filtered signal. Here we construct a 2*n_spikes array where the first row
% contains the position of the spike, and the second one contains the mean
% amplitude of the previous 1/4 cycle. An array is constructed for each
% filtered signal.
spike_trains = cell(1,length(cf));
for i = 1:length(cf)
    sp_tr = pg_zerocross(filtered(i,:));
    sp_tr(2,:) = mean_amp_computation(sp_tr,filtered(i,:),cf(i),param);
    spike_trains{i} = sp_tr;
end

%% Third step:
% Filter every spike train depending on the mean amplitude
% calculated. The last level is the less sensitive (i.e. the amplitude of
% the signal has to be relatively large for exciting this level). The
% number of levels is contained in the param.num_levels value. Adjacent
% levels are 3dB separated.
%%%%%%%%%%
% num_levels = param.num_levels;
% levels = zeros(param.n_channels,num_levels);
% levels(:,1) = param.min_levels;
% 
% for i = 2:num_levels
%     %each following level is sqrt(2) times the preceeding (i.e. 3dB)
%     levels(:,i) = levels(:,i-1)*1.414;
% end
% 
% AN = cell(size(filtered,1),1);
% for i = 1:size(filtered,1)
%     AN{i} = sensitivity_filter(spike_trains{i},levels(i,:));
% end
%%%%%%%%%%%%%%%%%
num_levels = param.num_levels;
levels = zeros(1,num_levels);
levels(1) = param.min_level;

for i = 2:num_levels
    %each following level is sqrt(2) times the preceding (i.e. 3dB)
    levels(i) = levels(i-1)*1.414;
end

AN = cell(size(filtered,1),1);
for i = 1:size(filtered,1)
    AN{i} = sensitivity_filter(spike_trains{i},levels);
end
%%%%%%%%%%%
toc
%% Fourth step:
% AN-like spike trains are passed through depressing synapses to a LIF
% neuron layer for detecting the onset.
tic
% Firstly the ODE system is solved. The cell C contains the evolution of
% the neurotransmitter in use (C(t)) for each channel and level.

%%%%%%%%%%%%%%%%%% ODE solver (ode45) %%%%%%%%%%%%%%%%%%%%%%%%
C = cell(length(param.cf),1);
h = waitbar(0,'Computing ODE system... 0%');
k = 0;
tot = length(AN)*param.num_levels;
for i = 1:length(AN)
    aux = cell(1,param.num_levels);
    for j = 1:param.num_levels
        [~,aux{j},~] = ODEsolver(AN{i}{j},length(input),param);
        k = k+1;
        waitbar(k/tot,h,sprintf('Computing ODE system... %d%%',...
            floor(100*k/tot)));
    end
    C{i} = aux;
end
%clear AN k tot % freeing memory space

close(h)
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% ODE solver (Euler approx.) %%%%%%%%%%%%%
% tic
% C_mat = ODEsolver_fast1(AN,length(input),param);
% 
% C = cell(length(param.cf),1);
% for i = 1:param.n_channels
%     aux = cell(1,param.num_levels);
%     for j = 1:param.num_levels
%         aux{j} = squeeze(C_mat(j,i,:))';
%     end
%     C{i} = aux;
% end
% toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
onset = cell(length(param.cf),1);
V = zeros(param.num_levels,param.n_channels,length(input));
for i = 1:length(param.cf)
    aux = cell(1,param.num_levels);
    for j = 1:param.num_levels
        Cadj = -1*ones(param.adj_ch*2+1,length(input));
        for k = -param.adj_ch:param.adj_ch
            Cadj(max(1,min(i+k,length(C))),:) = ...
                C{max(1,min(i+k,length(C)))}{j};
        end
        Cadj(all(Cadj==-1,2),:) = [];
        leak = compute_leak(i,param);
        [aux{j},V(j,i,:)] = LIFneuron(Cadj,leak,param);
    end
    onset{i} = aux;
end
clear C % freeing memory space


%% Fifth step:
% Once we have the onsets for each channel and signal level, they are
% grouped in order to reduce the sample rate of the onset spike trains and
% the number of parallel spike trains.
% The onset signal is time-sliced into windows of param.win_len seconds.
% For each channel, the strongest spike in the window is picked, and the
% sensitivity level of it is used to label the time slice of that freq. 
% channel.
%max_level = param.min_level*(1.414^(param.num_levels-1));
win_samples = round(param.win_len*param.Fs);
onset_fp = zeros(length(param.cf),...
    ceil(length(input)/(param.Fs*param.win_len)));

for i = 1:length(onset) % i is the freq. channel number
    ch_levels = zeros(param.num_levels,length(input));
    for j = 1:param.num_levels % j corresponds to the sensitivity level
        ch_levels(j,onset{i}{j}) = j;
    end
    k = 1;
    for j = 1:win_samples:length(input)
        onset_fp(i,k) = max(max(ch_levels(:,...
            j:min(length(input),j+win_samples-1))))/param.num_levels;
        k = k+1;
    end
end
