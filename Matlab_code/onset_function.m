function onset = onset_function(AN,input,param)

tic
C_mat = ODEsolver_fast2(AN,length(input),param);
toc

onset = LIFneuron_fast1(C_mat,param);