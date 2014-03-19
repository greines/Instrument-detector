function [M,C,R] = ODEsolver(spike_tr,len,param)
% This function solves the ODE system which defines the behavior of the
% three reservoir synapse model:
%
% dM/dt = beta*R - gamma*M;
% dC/dt = gamma*M - alpha*C;
% dR/dt = alpha*C - beta*R;
%
% where M is the available presynaptic neurotransmitter amount, C is the
% neurotransmitter currently in use and R is the neurotransmitter in the
% process of reuptake (not yet available for reuse).
% Alpha and beta are rate constants, and gamma is positive during a spike
% and 0 otherwise.
%
% This function uses the MATLAB built-in "ode45" ODE solver.

% initial conditions: M = 1, C = R = 0:
ic = [1;0;0];
Y = ic';

%define the temporal integration period
tspan_sp = linspace(1/param.Fs,3/param.Fs,3);

for i = 1:length(spike_tr)
    if i == 1
        sp_iminone = 1;
        tspan = linspace(1/param.Fs,max(3,(spike_tr(i)-1))/param.Fs,...
            max(3,spike_tr(i)-1));
    else
        sp_iminone = spike_tr(i-1);
        tspan = linspace(1/param.Fs,max(3,(spike_tr(i)-spike_tr(i-1)))...
            /param.Fs,max(3,spike_tr(i)-spike_tr(i-1)));
    end
    % solve ODE for the non-spike condition (gamma = 0)
    [~,aux] = ode45(@eq_definition_nonsp,tspan,ic);
    Y = vertcat(Y,aux(2:spike_tr(i)-sp_iminone,:));
    % set the initial conditions as the last sample of the non-spike
    % condition ODE for solving the spike condition ODE next
    ic = Y(spike_tr(i)-1,:);
    [~,aux] = ode45(@eq_definition_sp,tspan_sp,ic);
    % as the spike only occurs in one sample, we take the 2nd sample of the
    % solution (because the 1st contains the initial conditions)
    Y = vertcat(Y,aux(2,:));
    % set the IC with the latest result
    ic = Y(spike_tr(i),:);
    
    % after all the spikes, solve the non-spike ODE from the last spike to
    % the end of the input.
    if i == length(spike_tr)
        tspan = linspace(1/param.Fs,max(3,(len-spike_tr(i)+1))...
            /param.Fs,max(3,len-spike_tr(i)+1));
        [~,aux] = ode45(@eq_definition_nonsp,tspan,ic);
        Y = vertcat(Y,aux(2:len-spike_tr(i)+1,:));
    end
end

if(isempty(spike_tr))
    M = (ic(1)*ones(1,len))';
    C = (ic(2)*ones(1,len))';
    R = (ic(3)*ones(1,len))';
else
    M = Y(:,1);
    C = Y(:,2);
    R = Y(:,3);
end

% figure
% plot(M),hold on,plot(C,'r'),hold on,plot(R,'g')

function dy = eq_definition_sp(t,y)
% Definition of the differential equations for the spike condition
% (gamma > 0):

dy(1,1) = param.beta*y(3) - param.gamma*y(1); %y(1) = M; dy(1) = dM/dt;
dy(2,1) = param.gamma*y(1) - param.alpha*y(2); %y(2) = C; dy(2) = dC/dt;
dy(3,1) = param.alpha*y(2) - param.beta*y(3); %y(3) = R; dy(3) = dR/dt;

end

function dy = eq_definition_nonsp(t,y)
% Definition of the ODE system for the non-spike cond. (gamma = 0):

dy(1,1) = param.beta*y(3); %y(1) = M; dy(1) = dM/dt;
dy(2,1) = -param.alpha*y(2); %y(2) = C; dy(2) = dC/dt;
dy(3,1) = param.alpha*y(2) - param.beta*y(3); %y(3) = R; dy(3) = dR/dt;

end

end