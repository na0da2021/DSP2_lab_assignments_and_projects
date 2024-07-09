% Just clear
clc  ; clear all ; close all ;
%specify variables
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
%determine Jmin
Jmin = zeros(10, 1);
%determine sigma
sigma = var(d_n);
for i = 1 : 10
    order = i;
    %calculater R, P
    R = corrmat(u_n, u_n, order);
    P = crossmat(u_n, d_n, order);
    %find optimum weight
     Wo = inv(R) * P;
    %find Jmin
     Jmin(i) = sigma - dot((P.'), Wo);
end
% Plot
figure;
plot(Jmin, 'r-o', 'MarkerSize', 4, 'LineWidth', 2);

% Add labels and title
ylabel('J');
title('Cost Function');