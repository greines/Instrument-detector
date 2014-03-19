function AN = sensitivity_filter(spike_amp_train,levels)
% This function separates the spikes into different sensitivity levels,
% according to their mean amplitude of the preceeding quarter-cycle.
%
% Inputs:
% - spike_amp_train: 2*num_spikes matrix which contains the indexes of the
% spikes in the first row and their mean amplitude in the second one.
% - levels: vector which contains the threshold of each sensitivity level.
%
% Output:
% - AN: cell which contains the spikes divided by their level.

% inv_levels = fliplr(levels);
AN = cell(1,length(levels));
buffer = [];

for i = length(levels):-1:1
    AN{i} = buffer;
    AN{i} = [AN{i} spike_amp_train(1,(spike_amp_train(2,:)>=levels(i)))];
    buffer = AN{i};
    spike_amp_train(:,(spike_amp_train(2,:)>=levels(i))) = [];
    AN{i} = sort(AN{i});
end

% for i = 1:length(levels)
%     AN{i} = buffer;
%     AN{i} = [AN{i} spike_amp_train(1,(spike_amp_train(2,:)>=inv_levels(i)))];
%     buffer = AN{i};
%     spike_amp_train(:,(spike_amp_train(2,:)>=inv_levels(i))) = [];
%     AN{i} = sort(AN{i});
% end