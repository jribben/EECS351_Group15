function [Z, Y_hat, Y] = audioCompDemo(X, fs, std_threshold)
%audioCompDemo Summary of this function goes here
%   Detailed explanation goes here

Y = fft(X);
freq = 1:length(Y); 
Y_mean = mean(mean(abs(Y)));
Y_std = mean(std(abs(Y)));
threshold = Y_mean + std_threshold * Y_std;
Y_hat = Y;
Y_hat(abs(Y_hat) < threshold) = 0;
num_nonzero = sum(Y_hat(:,1) ~= 0);

figure(351);
subplot(2, 1, 1);

plot(freq, abs(dataFlip(Y)), freq, threshold * ones(1, length(Y)));xlabel('Frequency'); ylabel('Magnitude'); title('Uncompressed song');
subplot(2, 1, 2);
plot(freq, abs(dataFlip(Y_hat)), freq, threshold * ones(1, length(Y)));xlabel('Frequency'); ylabel('Magnitude'); title('Compressed song');

Z = ifft(Y_hat);
sound(Z, fs);

% Some informative data outputs
fprintf('\n');
disp('Use the command "clear sound" (no quotes) to stop the playback.');
fprintf('Original vector length: %10g\n', length(X));
fprintf('Compressed vector size: %10g\n', num_nonzero);
fprintf('Compression ratio (original / compressed): %6.2f\n\n', length(X) / num_nonzero);

end