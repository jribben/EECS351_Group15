%% DEMO FILE
close all; clear; clc;

%% OPTIONS

% AUDIO FILE
[audio_raw_in,fs] = audioread("whale_pilot.wav");

% SPECTROGRAM
window_size = 64; % adjust windowing (decrease for faster runtime)
window_overlap = [];
freq_range = 0:12000;

%% HIGH PASS PLOTS
figure('Name', 'High Pass Filters')
subplot(3,1,1);
spectrogram(audio_raw_in, window_size, window_overlap, freq_range, fs, 'yaxis');
title("unfiltered audio");
grid on;

subplot(3,1,2);
audio_filtered_5k = highpass(audio_raw_in, 5000, fs);
spectrogram(audio_filtered_5k, window_size, window_overlap, freq_range, fs, 'yaxis');
title("filtered audio using highpass filter at 5kHz");
grid on;

subplot(3,1,3);
audio_filtered_2k = highpass(audio_raw_in, 2000, fs);
spectrogram(audio_filtered_2k, window_size, window_overlap, freq_range, fs, 'yaxis');
title("filtered audio using highpass filter at 2kHz");
grid on;
sgtitle('High Pass Filters - Pilot Whale');

%% TARGETED MOVING AVERAGE FILTER
figure('Name', 'Targeted Moving Average Filter')

% audio split into low and high frequencies
audio_low = lowpass(audio_raw_in, 2000,fs);
audio_high = highpass(audio_raw_in, 4000, fs);

% time -> frequency domain
audio_fft = fft(audio_raw_in);
audio_fft_low = fft(audio_low);
audio_fft_high = fft(audio_high);
freq = 1:length(audio_fft); 

% moving average
audio_low_average = movmean(audio_low, 100);
audio_fft_low_average = fft(audio_low_average);
audio_low_average_highpass = highpass(audio_low_average, 500, fs);
audio_fft_low_average_highpass = fft(audio_low_average_highpass);

% combine both signals in frequency domain
audio_fft_combined = audio_fft_low_average_highpass + audio_fft_high;
audio_combined = ifft(audio_fft_combined);

subplot(3,1,1);
spectrogram(audio_raw_in, window_size, window_overlap, freq_range, fs, 'yaxis');
title("original signal", 'Interpreter', 'none');
grid on;

subplot(3,1,2);
spectrogram(audio_low_average_highpass, window_size, window_overlap, freq_range, fs, 'yaxis');
title("low frequencies after moving average", 'Interpreter', 'none');
grid on;

subplot(3,1,3);
spectrogram(audio_combined, window_size, window_overlap, freq_range, fs, 'yaxis');
title("filtered signal", 'Interpreter', 'none');
sgtitle('Targeted Moving Average Filter - Pilot Whale');

%% WIENER FILTER
% This implementation of the Wiener filter has been developed 
% by Jarvus Chen
% https://github.com/JarvusChen/MATLAB-Noise-Reduction-by-wiener-filter
figure('Name', 'Wiener Filter')

output = noiseReduction_YW(audio_raw_in, fs);

subplot(2,2,1)
plotWave_YW(0,audio_raw_in,fs,'time',1);
title('original signal');

subplot(2,2,2)
plotWave_YW(0,audio_raw_in,fs,'freq');
title('original signal spectrogram');

subplot(2,2,3)
plotWave_YW(0,output,fs,'time',1);
title('filtered signal');

subplot(2,2,4)
plotWave_YW(0,output,fs,'freq');;
title('filtered signal spectrogram');
sgtitle('Wiener Filter - Pilot Whale');