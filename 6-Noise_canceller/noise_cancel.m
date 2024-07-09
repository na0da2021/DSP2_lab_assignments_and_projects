N = 10000; % number of samples
M = 11;        % Order of filter
% Generate S(n)
n = 0:N-1;
s = chirp(n, 0, N, 0.01);
Pw = mean(s.^2);
figure(1);
plot(n/N,s);  % linear chirp signal

% Generate u(n)
u = randn(1, N+500);
u = u(501:end);
%figure;
%plot(n,u);

% Generate v(n)
LPF = fir1(M,0.5);
v = filter(LPF,1,u);
%figure;
%plot(n,v);

d = s + v;
sigma_d = var(d);
%figure;
%plot(n,d);

% Wiener Filter
%calculater R, P
order = M;
R = corrmat(u, u, order);
P = crossmat(u, d, order);
%find optimum weight
 Wo = inv(R) * P;
y_wiener = filter(Wo, 1, u);
e = d - y_wiener;  % error signal [system output signal]
MMSE = mean(e.^2);

figure(2);
plot(n/N, e);