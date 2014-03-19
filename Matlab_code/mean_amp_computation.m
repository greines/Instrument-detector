function amp = mean_amp_computation(sp_tr,signal,cf,param)
% This function calculates the mean amplitude of the signal in the previous
% quarter-cycle of the signal before a spike occurs.
%
% Inputs:
% - sp_tr: array which contains the location of the spikes.
% - signal: signal corresponding to that spike train
% - cf: central frequency of the gammatone filter
% - param: struct containing the main parameters of the project
%
% Output:
% - amp: mean amplitude

quarter_period = round(param.Fs/(4*cf));
amp = zeros(1,length(sp_tr));
for i = 1:length(sp_tr)
    chunk = (sp_tr(i)-quarter_period):sp_tr(i);
    if(chunk(1)<=0)
        % if the spike is early in the signal, avoid negative indexes
        chunk = 1:sp_tr(i);
    end
    amp(i) = sqrt(sum(signal(chunk).^2)/length(chunk));
end