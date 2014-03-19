function filtered = gammatone_filtering(input,cf,param)
% Gammatone filter bank implemented as described in the Holdsworth,J. et al
% "Implementing a GammaTone Filter Bank" (February 1988) paper.
%
% Inputs:
% - input: signal we want to filter
% - cf: central frequency of the filter
% - param: struct with the main parameters of the project
%
% Output:
% - filtered: filtered signal

Ts = 1/param.Fs;
n = param.order;
t = 1:length(input);
% ERB formula according to Moore and Glasberg (1983)
ERB = 6.23*10^(-6)*cf^2 + 93.39*10^(-3)*cf + 28.52;
an = (pi*factorial(2*n-2)*2^(-(2*n-2)))/((factorial(n-1))^2);
b = ERB/an; % bandwith of the gammatone filter

% Start by frequency shifting the input array by an amount of -cf Hz to
% produce the complex array z:
z = exp(-2*pi*1i*cf*t*Ts).*input;

% First order recursive filter. The output array w is introduced
% recursively into the filter n times
w = zeros(1,length(z));
for k = 1:n
    w = [w(1) w]; % mirroring technique for the first sample
    for p = 2:length(z)+1
        w(p) = w(p-1)+(1-exp(-2*pi*b*Ts)).*(z(p-1)-w(p-1));
    end
    w(1) = []; % remove the first sample added before
end

% Frequency shifting by +cf Hz. The real part is taken to produce the
% filtered output array

filtered = real(exp(2*pi*1i*cf*t*Ts).*w);
