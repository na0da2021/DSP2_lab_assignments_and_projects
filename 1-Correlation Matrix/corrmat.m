% %% moving average model
clear all; clc;
v = randn(1, 10000);
v_new = v([1001 : end]);
b = [1 -0.5];   % numerator coefficients
a = 1;             % denominator coefficients
u = filter(b, a, v_new);
% ------- correlation matrix--------
L = length(u);
r = zeros(1,5);
for i = 1:5
    sum = 0;
    for k = 1 : L- i+1; 
    sum =sum + (u(k) )*(u(k+i-1)); 
    end
    r(i) = (1/k)*sum;
end
R_MA = toeplitz(r)
%% Autoregressive model
b2 = 1;   % numerator coefficients
a2 = [1 -0.5];             % denominator coefficients
u = filter(b2, a2, v_new);
% ------- correlation matrix--------
r2 = zeros(1,5);
for i = 1:5
    sum = 0;
    for k = 1 : L- i+1; 
    sum =sum + (u(k) )*(u(k+i-1)); 
    end
    r2(i) = (1/k)*sum;
end
R_AR = toeplitz(r2)