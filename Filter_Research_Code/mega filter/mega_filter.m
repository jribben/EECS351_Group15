close all; clear; clc;

% read in .wav audio file
[audio_raw_in,fs] = audioread("audio_samples/whale_pilot.wav");

%% Splitting of the signal 

% audio_low signal contains only low frequencies
audio_low = lowpass(audio_raw_in, 2000,fs);

% audio_high signal contains only high frequencies
audio_high = highpass(audio_raw_in, 4000, fs);

% time -> frequency domain
audio_fft = fft(audio_raw_in);
audio_fft_low = fft(audio_low);
audio_fft_high = fft(audio_high);
freq = 1:length(audio_fft); 

%% Plot data to visualize the split
figure(1);
subplot(3, 1, 1);
plot(freq, abs(dataFlip(audio_fft)))
xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("Original signal - Frequency Domain");

subplot(3, 1, 2);
plot(freq, abs(dataFlip(audio_fft_low)))
xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("Low frequencies - Frequency Domain");

subplot(3, 1, 3);
plot(freq, abs(dataFlip(audio_fft_high)))
xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("High frequencies - Frequency Domain")

%% Moving average low frequencies
audio_low_average = movmean(audio_low, 100);
audio_fft_low_average = fft(audio_low_average);

figure(2);
subplot(2, 1, 1);
plot(audio_low);
title("Signal before moving average")
subplot(2, 1, 2);
plot(audio_low_average);
title("Signal after moving average")

%% Take high pass of resulting audio_low_average
audio_low_average_highpass = highpass(audio_low_average, 500, fs);


%% Combine the moving average signal with high frequencies
% TODO - need to put high frequencies on-top of low frequencies

% combine both signals in frequency domain
audio_fft_combined = audio_fft_low_average + audio_fft_high;

audio_combined = ifft(audio_fft_combined);

%% Spectrograms
% adjust windowing for spectrogram
% (decrease windowSize to increase speed of runtime)
window_size = 64;
window_overlap = [];
freq_range = 0:12000;

figure(3);
% plot spectrogram of original signal
subplot(6,1,1);
spectrogram(audio_raw_in, window_size, window_overlap, freq_range, fs, 'yaxis');
title("original signal - whale_pilot", 'Interpreter', 'none');
grid on;

% plot spectrogram of low frequencies of signal
subplot(6,1,2);
spectrogram(audio_low, window_size, window_overlap, freq_range, fs, 'yaxis');
title("SPLIT audio low frequencies", 'Interpreter', 'none');
grid on;

% plot spectrogram of high frequencies of signal
subplot(6,1,3);
spectrogram(audio_high, window_size, window_overlap, freq_range, fs, 'yaxis');
title("SPLIT audio high frequencies", 'Interpreter', 'none');
grid on;

% plot spectrogram of low frequencies of signal after moving average
subplot(6,1,4);
spectrogram(audio_low_average, window_size, window_overlap, freq_range, fs, 'yaxis');
title("low frequencies after only moving average", 'Interpreter', 'none');
grid on;

% plot spectrogram of low frequencies of signal after moving average WITH
% HP filter
subplot(6,1,5);
spectrogram(audio_low_average_highpass, window_size, window_overlap, freq_range, fs, 'yaxis');
title("low frequencies after moving average and high pass", 'Interpreter', 'none');
grid on;

subplot(6,1,6);
spectrogram(audio_combined, window_size, window_overlap, freq_range, fs, 'yaxis');
title("COMBINED audio low and high frequencies", 'Interpreter', 'none');
soundsc(audio_combined, fs);
