% This code plots the time domain and frequency domain 
% of given audio signal
clear all; close all; clc;
[signal,sample_rate] = audioread("whale_pilot.wav");

% Plot the time domain of the signal
sample_period = 1/sample_rate;
% Get axis in seconds
t = (0:sample_period:(length(signal)-1)/sample_rate);
subplot(2,1,1)
plot(t,signal)
xlabel("Time");
ylabel("Amplitude");
title("Time Domain");
grid on;

% Plot the frequency domain of the signal
Y = fft(signal);
signal_length = length(Y); 
n = pow2(nextpow2(signal_length));
y = fft(signal, n);
f = (0:n-1)*(sample_rate/n);
amplitude = abs(y)/n;
subplot(2,1,2);
plot(f(1:floor(n/2)),amplitude(1:floor(n/2)))
xlabel('Frequency');
ylabel('Magnitude');
title('Frequency Domain');
grid on;