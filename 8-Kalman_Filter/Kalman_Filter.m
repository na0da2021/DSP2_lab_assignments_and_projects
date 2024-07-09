clc; clear all; close all;

% Constants
dt = 1;  % Time step (1 second)
v = 2;   % Constant speed (2 m/s)

% Initial state
x = [30; 0; 40; 0];  % [x, vx, y, vy]
P = eye(4) * 1e4;     % Initial covariance matrix

% Process noise covariance
Q = eye(4);

% Measurement noise covariance
R = eye(2) * 4;

% State transition matrix
F = [1, dt, 0, 0;
     0, 1, 0, 0;
     0, 0, 1, dt;
     0, 0, 0, 1];

% Measurement matrix
H = [1, 0, 0, 0;
     0, 0, 1, 0];

% Kalman filter initialization
x_est = x;
P_est = P;

% Simulate tracking for 100 time steps
x_est_list = [];
y_est_list = [];
x_true_list = [];
y_true_list = [];
x_meas_list = [];
y_meas_list = [];

for t = 1:100
    % Update true state
    x = F * x + sqrt(Q) * randn(4, 1);
    % Generate measurement
    z = H * x + randn(size(H, 1), 1) * sqrt(R(1, 1));
    % Predict step
    x_pred = F * x_est;
    P_pred = F * P_est * F' + Q;

    % Update step
    K = P_pred * H' * inv(H * P_pred * H' + R);   

    % Update estimated state
    x_est = x_pred + K * (z - H * x_pred);
    P_est = (eye(4) - K * H) * P_pred;
    
    % Store estimated states
    x_est_list = [x_est_list, x_est(1)];
    y_est_list = [y_est_list, x_est(3)];
    
    % Store true states
    x_true_list = [x_true_list, x(1)];
    y_true_list = [y_true_list, x(3)];
    
    % Store measurements
    x_meas_list = [x_meas_list, z(1)];
    y_meas_list = [y_meas_list, z(2)];
    % Update true state
    x(1) = x(1) + v * dt;
    x(3) = x(3) + v * dt;
end

% Plot true and estimated positions
figure;
plot(x_true_list, y_true_list, 'g--', 'LineWidth', 2); % True path
hold on;
plot(x_est_list, y_est_list, 'b', 'LineWidth', 2); % Estimated path
scatter(x_meas_list, y_meas_list, 'rx'); % Measurements
xlabel('X position (m)');
ylabel('Y position (m)');
title('Kalman Filter Tracking of Vehicle');
grid on;
legend('True path', 'Estimated path', 'Measurements');

% Set axis limits
xlim([20, 110]);
ylim([40, 140]);

hold off;