function y=MakeErbCFs(lfhz,hfhz,n)


y=ErbRateToHz(linspace(HzToErbRate(lfhz),HzToErbRate(hfhz),n));
