function [all_audio,min_sample] = cutter(listnames, delay) 
[name,filenames] = xlsread(listnames); %excel file with dolphin names and folder names contaning audio samples
Fs = 44000; % target frequency
col_length = cast(.5*Fs,"single"); %target audio length
num_species = 10; 
all_audio = zeros(col_length,200,10);
delay_sample = cast(Fs*delay,"single");

for i=1:num_species
    fname = string(filenames(i,2));
    aname = string(filenames(i,1));
    currentpath = strcat(pwd,fname);
    Files=dir(currentpath);
    col = 1;
    for k=3:length(Files)
        %read audio from the file
        FileName = strcat(currentpath,'\',Files(k).name);
        [y,fs] = audioread(FileName);
        
        %resample the audio to 44kHz
        [P,Q] = rat(Fs/fs);
        audio = y(1:length(y),1);
        temp_audio = resample(audio,P,Q);
        
        %Filter options, uncomment one and run
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%% HIGHPASS %%%%%%%%%%%%%%%%%%%%%%%%%%
        
%        temp_audio = highpass(temp_audio, 5000, Fs);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%%%%%%%%%%%%%%%%%%%%%%%% TARGETED MOVING AVERAGE %%%%%%%%%%%%%%
        
%        % audio_low signal contains only low frequencies
%         audio_low = lowpass(temp_audio, 2000,Fs);
% 
%         % audio_high signal contains only high frequencies
%         audio_high = highpass(temp_audio, 4000, Fs);
%         
%         % time -> frequency domain
%         audio_fft = fft(temp_audio);
%         audio_fft_low = fft(audio_low);
%         audio_fft_high = fft(audio_high);
%         freq = 1:length(audio_fft); 
%         
%         % Moving average low frequencies
%         audio_low_average = movmean(audio_low, 100);
%         audio_fft_low_average = fft(audio_low_average);
%         
%         % Take high pass of resulting audio_low_average
%         audio_low_average_highpass = highpass(audio_low_average, 500, Fs);
%         audio_fft_audio_low_average_highpass = fft(audio_low_average_highpass);
% 
%         % combine both signals in frequency domain
%         audio_fft_combined = audio_fft_audio_low_average_highpass + audio_fft_high;
% 
%         temp_audio = ifft(audio_fft_combined);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%% WEINER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

         temp_audio = noiseReduction_YW(temp_audio,Fs);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %shift the signal with a given delay
        temp_audio = [zeros(delay_sample,1);temp_audio];
        
        % buffer the result (cut the audio into .5 second samples
        buffer_length = 0.5*Fs;
        cut_audio = buffer(temp_audio,buffer_length);
        [num_row,num_col] = size(cut_audio);
        
        % get rid of 0.5s segments that contain more than 10% of zeros
        % (2000 zeros) to limit biased training
        for var=1:num_col
            current = cut_audio(:,var);
            zeroSum = sum(current(:,1)==0);
            if zeroSum < 2000
                all_audio(1:buffer_length,col,i) = current;
                col = col+1;
            end
        end
    end
end

% find the minimum number of samples across the 10 species
% This minimum is the number of samples that can be used in the classifier
min_sample = 10000000;
for i=1:num_species
    current = all_audio(:,:,i);
    nonzeroSum = sum(current(1,:)~=0);
    if nonzeroSum < min_sample
        min_sample = nonzeroSum;
    end
end

