clc;
clear all;
close all;

% LMS Parameters
Inner_Iteration = 10000;
Outer_Iteration = 100;
alpha_values = [0.01 0.05 0.1];

% Initialize arrays
W = zeros(length(alpha_values), Inner_Iteration, Outer_Iteration);
f_n = zeros(length(alpha_values), Inner_Iteration, Outer_Iteration);

% Outer loop
for k = 1:Outer_Iteration
    % Generate noise signal
    v_n = sqrt(0.02) * randn(1, 10500);
    v_n = v_n(501:end);
    Num = 1;
    Dom = [1 0.99];
    
    % Generate input signal
    u_n = filter(Num, Dom, v_n);
    
    % Inner loop
    for i = 1:length(alpha_values)
        for j = 1:Inner_Iteration-1
            % Update filter coefficients
            f_n(i, j, k) = u_n(j) - W(i, j, k) * u_n(j+1);
            W(i, j+1, k) = W(i, j, k) + alpha_values(i) * u_n(j+1) * f_n(i, j, k);
        end
    end
end

% Calculate average weights and errors
W_avr = mean(W, 3);
f_n_avr = mean(f_n .^ 2, 3);

% Plotting
figure;

% Plot average weights
subplot(2, 1, 1);
plot(W_avr');
xlabel('Number of Iterations');
ylabel('Average Weight');
title('Average Weights (W0)');
legend('mu = 0.01', 'mu = 0.05', 'mu = 0.1');

% Plot average errors
subplot(2, 1, 2);
colors = {'r', 'b', 'm'};
for i = 1:length(alpha_values)
    plot(f_n_avr(i, :), 'color', colors{i});
    hold on;
end
xlabel('Number of Iterations');
ylabel('Average Error');
title('Average Error');
legend('mu = 0.01', 'mu = 0.05', 'mu = 0.1');