%Utilizing Alex's audioCompDemo 
[Y, Fs] = audioread('dolphin_whitesided.wav');
std_threshold = 1.5; 

X = Y(:,1);

% audioCompDemo already plays sound
[Z, Y_hat Y] = audioCompDemo(X, Fs, std_threshold);