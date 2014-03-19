function plot_comparison3(GRM,MJN,fast,channel)

 plot(MJN(channel,:))
 hold on,plot(fast(channel,:),'r')
 hold on,plot(GRM(channel,:),'g')
 legend('MJN','fast','GRM','Location','best')
 
 norm_GRM = GRM/max(max(abs(GRM)));
 norm_fast = fast/max(max(abs(fast)));
 norm_MJN = MJN/max(max(abs(MJN)));
 
 figure
 plot(norm_MJN(channel,:))
 hold on,plot(norm_fast(channel,:),'r')
 hold on,plot(norm_GRM(channel,:),'g')
 legend('Norm. MJN','Norm. fast','Norm. GRM','Location','best')