% Clear workspace, command window, and close all figures
clear; clc; close all;

% Read and convert image to grayscale
input_image = imread('dog.jpg');
gray_image = rgb2gray(input_image);

% Get the size of the original image
[height, width] = size(gray_image);

% Define block size and pad image
block_size = 4;

% Calculate padding needed to fit blocks
width_remainder = mod(width, block_size);
height_remainder = mod(height, block_size);
width_padding = block_size - width_remainder;
height_padding = block_size - height_remainder;

% Create a new image with padded dimensions
padded_width = width + width_padding;
padded_height = height + height_padding;
padded_image = zeros(padded_height, padded_width, 'uint8');

% Copy the original image into the new padded image
padded_image(1:height, 1:width) = gray_image;

% Pad the new image with zeros
padded_image(height+1:end, :) = 0;
padded_image(:, width+1:end) = 0;

% Divide image into blocks
num_rows = floor(size(padded_image, 1) / block_size);
num_cols = floor(size(padded_image, 2) / block_size);

% Split image into blocks
block_array = zeros(block_size, block_size, (num_rows * num_cols));
block_counter = 1;
for i = 1:num_rows
    for j = 1:num_cols
        block = padded_image((i-1)*block_size+1:i*block_size, (j-1)*block_size+1:j*block_size);
        block_array(:,:,block_counter) = block;
        block_counter = block_counter + 1;
    end
end

% Calculate mean of each block and sort
block_means = squeeze(mean(mean(block_array, 1), 2));
[~, sorted_indices] = sort(block_means);
block_array = block_array(:, :, sorted_indices);

% Initialize codebooks
codebook_sizes = [16, 64, 256, 1024];

% Create a single figure for all images
figure;

% Display original image
subplot(3, 2, 1);
imshow(padded_image);
title('Original');

% Calculate bits per pixel for original image
bpp_original = numel(gray_image) * 8 / (height * width);

for idx = 1:length(codebook_sizes)
    % Compression
    codebook_size = codebook_sizes(idx);
    region_range = 256 / codebook_size;
    codebook = zeros(block_size, block_size, codebook_size);
    region_centers = 0:region_range:256;
    
    iterations = 5;
    num_blocks = zeros(1, codebook_size);
    block_counter = 0;
    
    % Iterate for codebook refinement
    for iter = 1:iterations
        start_index = 1;
        for i = 1:codebook_size
            block_sum = 0;
            block_count = 0;
            for j = start_index:length(block_array)
                mean_val = mean2(block_array(:,:,j));
                block_counter = block_counter + 1;
                % Assign block to region based on mean value
                if (mean_val >= region_centers(i) && mean_val < region_centers(i+1))
                    block_sum = block_sum + block_array(:,:,j);
                    block_count = block_count + 1;
                else
                    break
                end
            end
            num_blocks(i) = block_count;
            start_index = start_index + block_count;
            % If no blocks assigned to this region, copy codebook from previous
            if block_count == 0
                if i == 1
                    codebook(:,:,i) = zeros(4, 4);
                else
                    codebook(:,:,i) = codebook(:,:,i-1);
                end
            else
                codebook(:,:,i) = floor(block_sum / block_count);
            end
        end
        % Update region centers based on mean of neighboring codebooks
        for i = 2:length(region_centers) - 1
            region_centers(i) = (mean2(codebook(:,:,i-1)) + mean2(codebook(:,:,i))) / 2;
        end
    end
    
    % Extraction
    reconstructed_image = zeros(padded_height, padded_width); % Updated to match padded dimensions
    num_codebooks = length(codebook);
    m = 1;
    y = num_blocks(1);
    for i = 1:num_codebooks
        for j = m:y
            x = sorted_indices(m);
            r = ceil(x / num_cols);
            c = x - num_cols * (r - 1);
            % Reconstruct image using codebook entries
            reconstructed_image((r-1)*block_size+1:r*block_size, (c-1)*block_size+1:c*block_size) = codebook(:,:,i);
            m = m + 1;
        end
        % Update block index range for next codebook
        if i ~= num_codebooks && i+1 <= length(num_blocks)
            y = y + num_blocks(i + 1);
        end
    end
    % Convert to uint8 for display
    reconstructed_image = uint8(reconstructed_image);
    
    % Display quantized image
    subplot(3, 2, idx + 1);
    imshow(reconstructed_image);
    title(['Quantized Image (K=' num2str(codebook_size) ')']);
    
    % Calculate mean squared error (MSE)
    MSE = sum((double(padded_image(:)) - double(reconstructed_image(:))).^2) / numel(padded_image);

    % Calculate SNR
    SNR_values(idx) = 10 * log10((mean(double(padded_image(:))).^2) / MSE);

    % Calculate compression ratio
    compression_ratios(idx) = 8 / (log2(codebook_size)/16);
end

% Display SNR and compression ratios
for idx = 1:length(codebook_sizes)
    disp(['For codebook size ' num2str(codebook_sizes(idx)) ':']);
    disp(['SNR: ' num2str(SNR_values(idx)) ' dB']);
    disp(['Compression Ratio: ' num2str(compression_ratios(idx))]);
end
