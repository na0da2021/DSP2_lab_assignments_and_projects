function sequence = laplace_rng(mu, b, n)
    % mu is the location parameter (mean)
    % b is the diversity (scale parameter)
    % n is the number of random numbers to generate

    % Uniform random numbers between -0.5 and 0.5
    u = rand(n, 1) - 0.5;

    % Inverse Laplace distribution function
    sequence = mu - b * sign(u) .* log(1 - 2*abs(u));
end