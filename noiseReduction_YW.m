function [output] = noiseReduction_YW(noisy, fs)
%%     Second Version by YI-WEN CHEN, 2018
%     Noise reduction by Wiener filter as following :
%     1. A convex combination of two DD approaches
%     2. Minimum mean squared error (MMSE) to estimate desired frame signal
%     3. Read more: https://medium.com/audio-processing-by-matlab/noisy-reduction-by-wiener-filter-by-matlab-44438af83f96
% 
%     Input Parameters: 
%       noisy    Noisy speech 
%       fs       Sampling rate (Hz)
%     Output Parameters:
%       output   Enhanced speech with above algorithms


%% parameters

ref_duration = 0.1*fs;  % referenced noisy for 0.1 sec

%% pre processing

ns_length = length(noisy);
frame_size = fix(0.032*fs);
NFFT = 2*frame_size;
han_win = hanning(frame_size);

ref_data = zeros(NFFT, 1);
for m = 0:ref_duration
	ref_frame = noisy(m+1:m+frame_size).*han_win;	
	ref_data = ref_data + abs(fft(ref_frame,NFFT)).^2;
end
ref = ref_data/ref_duration;

%% main
overlap = fix(0.5*frame_size);
offset = frame_size - overlap;

frame_num = fix((ns_length - NFFT)/offset);
spectrum_old = zeros(NFFT, 1);
output = zeros(ns_length, 1);

min_SNR = 0.1;
alpha = 0.98;

for m = 0 : frame_num
    
	begin = m*offset + 1;    
    finish = m*offset + frame_size;   
    frame = noisy(begin:finish);
    
	frame_win = han_win.*frame;
	frame_fft = fft(frame_win, NFFT);
   
	frame_phase = angle(frame_fft);
	frame_mag = abs(frame_fft);

    SNR = ((frame_mag.^2) ./ ref) - 1 ;
	SNR = max(SNR, min_SNR);
   
    eta = alpha*( (spectrum_old.^2)./ref ) + (1 - alpha)*SNR;
    eta = max(eta, -19);
	spectrum = (eta./(eta+1)).* frame_mag;
   
    frame_fft = spectrum.*exp(i*frame_phase);   
    output(begin:begin+NFFT-1) = output(begin:begin+NFFT-1) + real(ifft(frame_fft, NFFT));
    spectrum_old = spectrum; % this line is comment out in p code
    
end
