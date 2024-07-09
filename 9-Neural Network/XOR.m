%just clear
clc;clear all;close all;
%input data
x1 = [0, 0, 1, 1];
x2 = [0, 1, 0, 1];
x = [x1; x2];
%extract weights and bias
parameters = netbp;
W2 = parameters.W2;
W3 = parameters.W3;
b2 = parameters.b2;
b3 = parameters.b3;
%calculate first layer
v1 = W2(1, :) * x + b2(1, 1);
v2 = W2(2, :) * x + b2(2, 1);
%hard limiter for first layer
y1 = 1./(1 + exp(-v1));
y2 = 1./(1 + exp(-v2));
y = [y1; y2];
%second layer
v3 = W3 * y + b3;
%second hard limiter(Output)
y3 = 1./(1 + exp(-v3));

