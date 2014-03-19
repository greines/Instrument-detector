% Script showing the results obtained. 18/06/2013

% 1st: SPEED-UP OF ALL THE ODE SOLVERS.
% Comparison between the C reservoir evolution computed with MATLAB ode45
% solver (Slow) and an Euler numerical approximation (Fast)
figure
subplot(221)
plot(squeeze(C_fast(1,1,:)),'r')
hold on, plot(C{1}{1},'b')
legend('Fast','Slow')
title('C reservoir evolution, ch1 lev1')
subplot(222)
plot(squeeze(C_fast(1,7,:)),'r')
hold on, plot(C{7}{1},'b')
legend('Fast','Slow')
title('C reservoir evolution, ch7 lev1')
subplot(223)
plot(squeeze(C_fast(6,8,:)),'r')
hold on, plot(C{8}{6},'b')
legend('Fast','Slow')
title('C reservoir evolution, ch8 lev6')
subplot(224)
plot(squeeze(C_fast(1,15,:)),'r')
hold on, plot(C{15}{1},'b')
legend('Fast','Slow')
title('C reservoir evolution, ch15 lev1')
pause


% 2nd: ONSET COMPARISON BETWEEN GRM AND MJN (whole process)
% The onset output is compared between the complete GRM (AN + onset
% encoding) and the complete MJN systems
figure
% subplot(211)
% plot_onset_filt(onset_MJN_grm,filtered_GRM,1,param)
% title('MJN onsets ch1')
% subplot(212)
plot_onset_filt(onset_GRM,filtered_GRM,1,param)
title('GRM onsets ch1')

figure
% subplot(211)
% plot_onset_filt(onset_MJN_grm,filtered_GRM,5,param)
% title('MJN onsets ch5')
% subplot(212)
plot_onset_filt(onset_GRM,filtered_GRM,5,param)
title('GRM onsets ch5')

figure
% subplot(211)
% plot_onset_filt(onset_MJN_grm,filtered_GRM,12,param)
% title('MJN onsets ch12')
% subplot(212)
plot_onset_filt(onset_GRM,filtered_GRM,12,param)
title('GRM onsets ch12')
pause

% 3rd: COMPARISON BETWEEN GRM AND MJN AN
% AN spikes are computed with each system (GRM and MJN), but the onset
% spikes are both computed with GRM system
figure
subplot(211)
plot_onset_filt(onset__anMJN_onsGRM,filtered_GRM,1,param)
title('MJN onsets (computed with GRMonset) ch1')
subplot(212)
plot_onset_filt(onset_GRM,filtered_GRM,1,param)
title('GRM onsets ch1')

figure
subplot(211)
plot_onset_filt(onset__anMJN_onsGRM,filtered_GRM,5,param)
title('MJN onsets (computed with GRMonset) ch5')
subplot(212)
plot_onset_filt(onset_GRM,filtered_GRM,5,param)
title('GRM onsets ch5')

figure
subplot(211)
plot_onset_filt(onset__anMJN_onsGRM,filtered_GRM,12,param)
title('MJN onsets (computed with GRMonset) ch12')
subplot(212)
plot_onset_filt(onset_GRM,filtered_GRM,12,param)
title('GRM onsets ch12')
pause

% 4th: ONSET FINGERPRINT
figure
subplot(311)
imagesc(ofp_GRM)
title('Onset fingerprint of trombone MIDI')
subplot(312)
imagesc(ofp_violin_GRM(:,1:130))
title('Onset fingerprint of violin')
subplot(313)
imagesc(ofp_Brass_GRM(:,240:370))
title('Onset fingerprint of Brass')
