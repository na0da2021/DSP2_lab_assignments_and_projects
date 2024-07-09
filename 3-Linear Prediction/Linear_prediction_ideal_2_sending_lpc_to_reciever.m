clc ;clear all; close all;
[speech,fs] = audioread('speech.opus');
frame_size= 0.015*fs;
frame_numbers= ceil(length(speech)/frame_size);
zeropadding = zeros(frame_size*frame_numbers-length(speech),1);
x=[speech; zeropadding];
for i=1:frame_numbers
    start_index= frame_size*(i-1)+1;
    end_index= frame_size*i;
    frame=x(start_index:end_index);
    [a,g]= lpc(frame,12);
    output_noise= filter(a',1,frame);
    predicted_speech(start_index:end_index,1) = filter(1,a',output_noise);
end
predicted_speech=predicted_speech(1:length(speech));
t=linspace(0,length(speech)/fs,length(speech));
subplot(2,1,1);
plot(t,speech);
title('Transmitted Speech')
xlabel('time');
ylabel('amplitude');
soundsc(speech,fs)
pause(2)
subplot(2,1,2);
plot(t,speech);
title('Predicted Speech')
xlabel('time');
ylabel('amplitude');
soundsc(predicted_speech,fs)
