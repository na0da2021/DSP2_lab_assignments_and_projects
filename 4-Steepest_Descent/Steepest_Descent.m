% Just clear
clc  ; clear all ; close all ;
%find the optimum weights using theoritical form
variance_1 = 0.27;
variance_2 = 0.1;
filter_size = 10000;
v1 = randn(1, filter_size + 500);
v1 = v1(501:end) * sqrt(variance_1);
v2 = randn(1, filter_size + 500);
v2 = v2(501:end) * sqrt(variance_2);
%design filter
b1 = 1;
a1 = [1 0.8458];
b2 = 1;
a2 = [1 -0.9458];
%determine d(n)
d_n = filter(b1, a1, v1);
%determine u(n)
u_n = v2 + filter(b2, a2, d_n);
%determine sigma
sigma = var(d_n);
order = 4;
%calculater R, P
R = corrmat(u_n, u_n, order);
P = crossmat(u_n, d_n, order);
%find optimum weight
Wo = inv(R) * P;
%find Jmin
Jmin = sigma - dot((P.'), Wo);
%find the optimum weights using Steepest descent
mu = [0.1, 0.2, 0.3, 0.4, 0.5];
for k = 1:5
 W_steepest = zeros(4,1);
J_min_steepest = zeros(1, 100);
for i = 0 : 100
    W_steepest = W_steepest +mu(k) *(P - (R * W_steepest));
    J_min_steepest(i+1) = sigma - dot((P.'), W_steepest);
end
plot(J_min_steepest);
hold on;
end
title('learning curve');
hold off;