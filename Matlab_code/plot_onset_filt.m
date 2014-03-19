function plot_onset_filt(onset,filtered,channel,param)

filt_sig = filtered(channel,:);
ch_levels = zeros(param.num_levels,length(filt_sig));
for j = 1:param.num_levels % j corresponds to the sensitivity level
    ch_levels(j,onset{channel}{j}) = j;
end

onset_plot = max(ch_levels);
onset_plot(onset_plot == 0) = NaN;

t_axis = linspace(1,length(filt_sig),length(filt_sig))/param.Fs;

[AX,~,H2] = plotyy(t_axis,filt_sig,t_axis,onset_plot,'plot','stem');
set(AX(1),'YLim',[-max(filt_sig)*1.3 max(filt_sig)*1.3])
set(AX(1),'YTick',[-1:0.25:1])
set(AX(2),'YLim',[-param.num_levels-1 param.num_levels+1])
set(AX(2),'YTick',[-param.num_levels:5:param.num_levels])
set(AX(1),'box','off')
xlabel('Time')
set(H2,'Marker','x')
set(get(AX(1),'Ylabel'),'string','Amplitude')
set(get(AX(2),'Ylabel'),'string','Onset spikes')