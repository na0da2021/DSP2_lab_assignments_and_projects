clc;
clear all;
close all;

% Read the image
image = imread('dog.jpg');

% Determine image dimensions
[height, width] = size(image);

% Define block size
block_size = 4;

% Calculate number of rows and columns for block division
rows = floor(height / block_size);
cols = floor(width / block_size);

% Create an array to store the divided image blocks
divided_image = zeros(block_size, block_size, height*width);

% Counter for storing blocks
Counter = 1;

% Divide the image into blocks
for i = 1 : rows
    for j = 1 : cols
        block = image((i-1)*block_size + 1 : i*block_size, (j-1)*block_size + 1 : j*block_size);
        divided_image(:, :, Counter) = block;
        Counter = Counter + 1;
    end
end

% Calculate mean of each block and sort
block_means = squeeze(mean(mean(divided_image, 1), 2));
[~, sorted_indices] = sort(block_means);
divided_image = divided_image(:, :, sorted_indices);

% Initialization of codebook sizes
codebook_sizes = [16, 64, 256, 1024];

% Create a figure for displaying images
figure;

% Display original image
subplot(3, 2, 1);
imshow(image);
title('Original Image');

% LBG algorithm
for CB = 1 : length(codebook_sizes)
    codebook_size = codebook_sizes(CB);
    voroni_range = 256 / codebook_size;
    
    % Initialization of voroni regions
    voroni_regions = 0 : voroni_range : 256;
    
    % Initialization of codebook
    codebook = zeros(block_size, block_size, codebook_size);
    iterations = 5;
    
    % Store the number of blocks for each region
    num_blocks = zeros(1, codebook_size);
    
    % LBG iterations
    for iter = 1 : iterations
        start = 1;
        for i = 1 : codebook_size
            sum_blocks = 0;
            number_of_blocks = 0;
            for j = start : length(divided_image)
                % Find the mean value of each block
                mean_value = mean2(divided_image(:, :, j));
                % Check if the block belongs to each voronoi region
                if(mean_value >= voroni_regions(i) && mean_value < voroni_regions(i+1))
                    sum_blocks = sum_blocks + divided_image(:, :, j);
                    number_of_blocks = number_of_blocks + 1;
                else
                    break;
                end
            end
            num_blocks(i) = number_of_blocks;
            start = start + number_of_blocks;
            if number_of_blocks == 0
                if i == 1 % First codebook
                    codebook(:, :, i) = zeros(4, 4);
                else % Copy the same codebook to the last one
                    codebook(:, :, i) = codebook(:, :, i-1);
                end
            else
                codebook(:, :, i) = floor(sum_blocks / number_of_blocks);
            end
        end
        % Update voronoi regions
        for i = 2 : length(voroni_regions) - 1
            voroni_regions(i) = (mean2(codebook(:,:,i-1)) + mean2(codebook(:,:,i))) / 2;
        end
    end
    % Extraction
    reconstructed_image = zeros(rows * block_size, cols * block_size);
    num_codebooks = length(codebook);
    m = 1;
    y = num_blocks(1);
    for i = 1:num_codebooks
        for j = m:y
            x = sorted_indices(m);
            r = ceil(x / cols);
            c = x - cols * (r - 1);
            reconstructed_image((r-1)*block_size+1:r*block_size, ...
(c-1)*block_size+1:c*block_size) = codebook(:,:,i);
            m = m + 1;
        end
        if i ~= num_codebooks && i+1 <= length(num_blocks)
            y = y + num_blocks(i + 1);
        end
    end
    reconstructed_image = uint8(reconstructed_image);
    reconstructed_image = reconstructed_image(1:300,1:300);
    
    % Display quantized image
    subplot(3, 2, CB + 1);
    imshow(reconstructed_image);
    title(['Quantized Image (K=' num2str(codebook_size) ')']);
    
    
end
