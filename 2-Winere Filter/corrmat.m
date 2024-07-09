% Auto_Correlation Matrix [R]
function [ R ] = corrmat(u_n, g_n, taps)
r = zeros(taps, 1);
L = length(u_n);
for i = 0:taps-1
    sum = dot(u_n(1 : end-i), g_n(i+1 : end));
    r(i + 1) = sum / (length(u_n) - i);
    
end
R = toeplitz(r);
end