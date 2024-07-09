% Clear workspace, close all figures, and clear command window
clear; close all; clc;

% Read the grayscale image
original_image = imread('gray.jpeg');

% Convert original image to double
original_image_double = im2double(original_image);

% Get the size of the original image
original_size = numel(original_image);

% Create a figure with 2x2 subplots
figure;

% Display the original image in the first subplot
subplot(2, 2, 1);
imshow(original_image);
title('Original Image');

% Initialize arrays to store MSE, SNR, and compression ratio values
mse_values = zeros(1,3);
snr_values = zeros(1,3);
compression_ratio_values = zeros(1,3);

% Loop over different values of n which represent the number of bits
for n = 1:3
    % Calculate the number of levels and step size
    L = 2^n;
    StepSize = 255 / L;
    
    % Quantize the image
    Level_I = floor(double(original_image) / StepSize);
    quantized_image = uint8(Level_I .* StepSize);
    
    % Display the quantized image in the subplot
    subplot(2, 2, 1 + n);
    imshow(quantized_image);
    title(['Quantized Image (n = ' num2str(n) ')']);
    
    % Calculate MSE
    mse = immse(original_image, quantized_image);
    mse_values(n) = mse;
    
    % Calculate SNR
    snr_value = 10 * log10((norm(original_image_double, 'fro')^2) / mse);
    snr_values(n) = snr_value;
    
    % Calculate compression ratio
    bits_per_pixel = log2(L);
    quantized_size = bits_per_pixel * original_size;
    compression_ratio = original_size / quantized_size;
    compression_ratio_values(n) = compression_ratio;
    
    % Display MSE, SNR, and compression ratio
    disp(['For n = ' num2str(n)]);
    disp(['MSE: ' num2str(mse)]);
    disp(['SNR: ' num2str(snr_value) ' dB']);
    disp(['Compression Ratio: ' num2str(compression_ratio)]);
end

% Display overall MSE, SNR, and compression ratio values
disp('Overall Results:');
disp(['MSE values: ' num2str(mse_values)]);
disp(['SNR values (dB): ' num2str(snr_values)]);
disp(['Compression Ratio values: ' num2str(compression_ratio_values)]);
