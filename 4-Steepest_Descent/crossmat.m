function  [ P ] = crossmat(u_n, d_n, order) 
    P = zeros(order, 1);
    L = length(u_n);
for j = 0:order-1
    sum = dot(u_n(1 : end-j), d_n(j+1 : end));
    P(j + 1) = sum / (length(u_n) - j);
    
end