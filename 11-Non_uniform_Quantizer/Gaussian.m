clear all; close all; clc;
data=randn(20000,1);
data=data(end-9999:end);
N = length(data);
data_sorted = sort(data);
numlevels=6;
b = norminv(linspace(0, 1, numlevels+1), 0, 1)

total=zeros(1,numlevels);
summation=zeros(1,numlevels);

for iterations=1:100 % Increased iteration limit for convergence
  for i=1:numlevels
    % Logical indexing for vectorized bin counting and summing
    in_bin = data_sorted >= b(i) & data_sorted < b(i+1);
    total(i) = sum(in_bin);
    summation(i) = sum(data_sorted(in_bin));
    if total(i) > 0
      y(i)= summation(i)/ total(i);
      MSE(i) =  sum((data_sorted(in_bin)-y(i)).^2);
      SNR= -10*log10((sum(MSE)/N));
    else
      y(i) = (b(i) + b(i+1)) / 2; % Handle empty bins
    end
  end 

  % Update boundaries based on new centroids
  for k=1:numlevels-1
      b(k+1)= (y(k)+y(k+1))/2;
  end 

end 
numlevels
y
b
SNR
