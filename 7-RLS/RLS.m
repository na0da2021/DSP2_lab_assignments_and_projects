clear all; clc;
% Order of the adaptive_filter
order = 7;
%Random_noise (1)
N = 10000;
n = 2*randi([0,1 ], 1, N+1000)-1;
n = n(1001: end).';

%channel Response 
nn = 0:10 ;
h_n = 1 ./ (1+ (nn-5).^2);
% figure(1);
% stem(nn, h_n);
% title('Channl impulse response');
% xlabel('n');
% ylabel('h[n]');
 

channel_output = conv(n, h_n).';
g = length(channel_output);             %noise added at generator(2)
n_g2 = sqrt(0.0015)*randn(1, g+1000);
n_g2 = n_g2(1001: end);
u_adaptive_filter = channel_output + n_g2;
d_adaptive_filter =horzcat( [0 0 0 0 0 0 0 0] ,n.',[0 0]);

%winer solution
%calculater R, P
R = corrmat(u_adaptive_filter, u_adaptive_filter, order);
P = crossmat(u_adaptive_filter, d_adaptive_filter, order);
%find optimum weight
Wo_winer = inv(R) * P;

%RLS Algorithm
%RlS Operators
delta = 0.004;
lamda = 1;

% Number of independent runs
num_runs = 100;
% Store the final weights for each run
W_RLS_runs = zeros(order, num_runs);
% Store the error signal for each run
e_runs = zeros(N, num_runs);

for run = 1:num_runs
    % Reset RLS variables for each run
    W_RLS = zeros(order, 1);
    P_RLS = (1/delta) * eye(order);
    
    % Store the error for each iteration
    e_iter = zeros(N, 1);
    
    for i = order+1:length(u_adaptive_filter)
        u = u_adaptive_filter(i:-1:i-order+1).';
        d = d_adaptive_filter(i);
        pi = P_RLS * u;
        k = (pi) / (lamda + u.' * pi);
        e = d - W_RLS.' * u;
        W_RLS = W_RLS + k * e;
        P_RLS = (1/lamda) * (P_RLS - k * u.' * P_RLS);
        
        % Store the error for this iteration
        if i  <= N+order 
        e_iter(i-order) = e;
        end
    end
    
    % Store the final weights and error signal for this run
    W_RLS_runs(:, run) = W_RLS;
    e_runs(:, run) = e_iter;
end

% Calculate the average final weights and error signal
avg_W_RLS = mean(W_RLS_runs, 2);
avg_e = mean(e_runs, 2);
