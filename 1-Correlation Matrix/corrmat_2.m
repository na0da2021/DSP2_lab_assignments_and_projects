% Another Representation using dot product
v_n = randn(11000, 1);
v_n_new = v_n(1001 : 10000);
b_1 = 1;
a_1 = [1 -0.5];
u_n = filter(b_1, a_1, v_n_new);
r = zeros(5, 1);
L = length(u_n);
for i = 0:4
    sum = dot(u_n(1 + i : end), u_n(1 : end - i));
    r(i + 1) = sum / (length(u_n) - i);
    
end
R = toeplitz(r);