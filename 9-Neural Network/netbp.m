function [parameters] = netbp
%NETBP Uses backpropagation to train a network
%%%%%%% DATA %%%%%%%%%%%
x1 = [0, 0, 1, 1];
x2 = [0, 1, 0, 1];
y = [0, 1, 1, 0];
% Initialize weights and biases
rng(5000);
W2 = 0.5*randn(2,2); W3 = 0.5*randn(1,2);
b2 = 0.5*randn(2,1); b3 = 0.5*randn(1,1);
% Forward and Back propagate
eta = 0.05; % learning rate
Niter = 1e6; % number of SG iterations
savecost = zeros(Niter,1); % value of cost function at each iteration
for counter = 1:Niter
k = randi(4); % choose a training point at random
x = [x1(k); x2(k)];
% Forward pass
a2 = activate(x,W2,b2);
a3 = activate(a2,W3,b3);
% Backward pass
delta3 =a3.*(1-a3).*(a3-y(:,k)); 
delta2 = a2.*(1-a2).*(W3'*delta3);
% Gradient step
W2 = W2 - eta * delta2 * x';
W3 = W3 - eta * delta3 * a2';
b2 = b2 - eta * delta2;
b3 = b3 - eta * delta3;
% Monitor progress
newcost = cost(W2,W3,b2,b3); % display cost to screen
savecost(counter) = newcost;
end
% Show decay of cost function
save costvec
semilogy([1:1e4:Niter],savecost(1:1e4:Niter))
% Weights = [W2(1, 1) W2(1, 2); W2(2, 1) W2(2, 2); W3(1, 1) W3(1, 2)];
% Bias = [b2(1, 1) b2(2, 1) b3];
parameters.W2 = W2;
parameters.W3 = W3;
parameters.b2 = b2;
parameters.b3 = b3;
function costval = cost(W2,W3,b2,b3)
costvec = zeros(4,1);
for i = 1:4
x =[x1(i);x2(i)];
a2 = activate(x,W2,b2);
a3 = activate(a2,W3,b3);
costvec(i) = norm(y(:,i) - a3,2);
end
costval = norm(costvec,2)^2;
end % of nested function
end

