clear all; close all; clc;

% Load an image
img = imread('girl.JPEG');
if size(img,3) == 3 % Check if the image is RGB
    img = rgb2gray(img); % Convert to grayscale
end

% Perform 2-level discrete wavelet transform
[LL, LH, HL, HH] = dwt2(img,'bior1.3');

% Display original image and subbands of 1st stage
figure;
subplot(2,2,1);
imshow(LL,[]);
title('LL subband');

subplot(2,2,2);
imshow(LH,[]);
title('LH subband');

subplot(2,2,3);
imshow(HL,[]);
title('HL subband');

subplot(2,2,4);
imshow(HH,[]);
title('HH subband');

% Perform 2-level discrete wavelet transform on LL(2nd stage)
[LL2, LH2, HL2, HH2] = dwt2(LL,'bior1.3');

% Display original image and subbands of 2nd stage
figure;
subplot(2,2,1);
imshow(LL2,[]);
title('LL subband 2nd stage');

subplot(2,2,2);
imshow(LH2,[]);
title('LH subband 2nd stage');

subplot(2,2,3);
imshow(HL2,[]);
title('HL subband 2nd stage');

subplot(2,2,4);
imshow(HH2,[]);
title('HH subband 2nd stage');

% Perform 2-level discrete wavelet transform on LL2 (3rd stage)
[LL3, LH3, HL3, HH3] = dwt2(LL2,'bior1.3');

% Display original image and subbands of 2nd stage
figure;
subplot(2,2,1);
imshow(LL3,[]);
title('LL subband 3rd stage');

subplot(2,2,2);
imshow(LH3,[]);
title('LH subband 3rd stage');

subplot(2,2,3);
imshow(HL3,[]);
title('HL subband 3rd stage');

subplot(2,2,4);
imshow(HH3,[]);
title('HH subband 3rd stage');