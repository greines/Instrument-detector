function y=ErbRateToHz(x)

% See 'Psychology of Hearing', p.74
y=(10.^(x/21.4)-1)/4.37e-3;
