clear all; %close all;
[speech,fs] = audioread('speech.opus');
frame_size= 0.015*fs;
frame_numbers= ceil(length(speech)/frame_size);
zeropadding = zeros(frame_size*frame_numbers-length(speech),1);
x=[speech; zeropadding];
linear_coeffecients= zeros(13,frame_numbers);
noise_power= zeros(1,frame_numbers);
%transmitter
for i=1:frame_numbers
    start_index= frame_size*(i-1)+1;
    end_index= frame_size*i;
    frame=x(start_index:end_index);
  for j=1:13
      [a,g]= lpc(frame,12);
      linear_coeffecients(j,i)= a(j);
      noise_power(i)= g;
  end 
end
%reciever 
predicted_speech= zeros(frame_size,frame_numbers);
Zi= zeros(12,frame_numbers);
for i = 1:frame_numbers
    N= randn(20000,1);
    N=N(20000-(frame_size-1):end,1);
    white_noise= sqrt(noise_power(i))* N;   
    [predicted_frame,Zf]= filter(1,linear_coeffecients(:,i),white_noise,Zi(:,i));
    Zi(:,i+1)=Zf;
    for j= 1:frame_size
        predicted_speech(j,i)= predicted_frame(j); 
    end
end
y=predicted_speech(:);
out_speech= y(1:length(speech));
t=linspace(0,length(speech)/fs,length(speech));
figure;
subplot(2,1,1);
plot(t,speech);
title('Transmitted Speech')
xlabel('time');
ylabel('amplitude');
soundsc(speech,fs)
pause(2)
subplot(2,1,2);
plot(t,out_speech);
title('Predicted Speech')
xlabel('time');
ylabel('amplitude');
soundsc(out_speech,fs)
