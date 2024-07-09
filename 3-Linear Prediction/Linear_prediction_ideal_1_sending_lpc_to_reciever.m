clc;
clear all;

% Read audio file and get sampling frequency
[y, Fs] = audioread('eric.wav');
%sound(y, Fs);
%pause(8);

fs_new = 48000;
y_new = (Fs / fs_new) * resample(y, fs_new, Fs);
%sound(y, Fs);
%pause(8);

audio_len = length(y_new);
% Define segment parameters
time_len = 0.015;   % Segment duration in seconds
order = 12;             % LPC order

% Calculate segment length
segment_len = time_len * fs_new;
num_segments = floor(audio_len / segment_len);

est_speech = zeros(audio_len, 1);

for i = 1 : num_segments
    % Extract single segment for analysis
    start_index = (i - 1) * segment_len + 1;
    end_index = i * segment_len;
    x = y_new(start_index:end_index);
    
    % Calculate LPC coefficients
    [a, g] = lpc(x, order);
    
    % Apply LPC filter to the segment
    output = filter(a, 1, x);
    
    % Receiver side
    est_speech(start_index:end_index) = filter(1, a, output);
end

% Plot original and predicted speech segments
t = (0:length(y_new) - 1) / fs_new;
figure;
subplot(2, 1, 1);
plot(t, y_new);
title('Original Speech');
xlabel('Time (s)');
ylabel('Amplitude');
%sound(y_new, fs_new);


subplot(2, 1, 2);
plot(t, est_speech);
title('Predicted Speech');
xlabel('Time (s)');
ylabel('Amplitude');
sound(est_speech, fs_new);