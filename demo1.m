% Demo for instructors
% Overview:
% 1. Call cutter.m to cut and filter data into 0.5s segments (Weiner)
% 2. Extract all audio features
% 3. Trained classifier models already exist (Weiner_SVM.mat and Weiner_Tree.mat)
% 4. Call the model and input test data (Weiner_Test.mat)
% 5. Display accuracies

clear all;
clc;

test_name = 'filenames.xlsx'; %excel sheet with file names and species names
[name,filenames] = xlsread(test_name); %read in excel sheet
Fs = 44000; % target frequency
col_length = .5*Fs; %target audio length
num_species = 10; %total number of species

% call cutter.m
% get 2 data sets: non-delayed and delayed(0.25s)
% 50 samples to train, 10 samples to test (per species)
[temp_audio1, min_sample] = cutter(test_name,0);
[temp_audio2, min_sample_delayed] = cutter(test_name,.25);
total_sample = 60;

% generate a zero matrix for the full audio matrix with 
all_audio = zeros(col_length,total_sample);

%combine the temp_audio files into one matrix
%seperate 10 test samples from 50 train samples later in file
for j=1:num_species
    for i=1:min_sample
        all_audio(:,i,j) = temp_audio1(:,i,j);
    end
end
for j=1:num_species
    for i=1:min_sample_delayed
        all_audio(:,min_sample+i,j) = temp_audio2(:,i,j);
    end
end

% clear the temp audio files (big files)
clear temp_audio1;
clear temp_audio2;

% calculate the spectral centroid for all samples across 10 species 
for i=1:num_species
    current_mat = all_audio(:,:,i);
    for j=1:total_sample
        current_sig = current_mat(:,j);
        spec_centroid(:,j,i) = spectralCentroid(current_sig,Fs);
    end
end


% calculate the MFC coefficents for all samples across 10 species
for i=1:num_species
    current_mat = all_audio(:,:,i);
    for j=1:total_sample
        current_sig = current_mat(:,j);
        temp = mfcc(current_sig,Fs);
        mel_coeff(:,j,i) = temp(:);
    end
end

% Single sided amplitude spectrum (frequency vs. amplitude)
% General Idea
% 1. take a sample and claculate the full length fft
% 2. Normalize the fft coefficients
% 3. Find the Magnitude
% 4. Extract the first 1/2 of the fft coefficients (no need for negative
% frequinces
% 5. Extract the even indexed values (positive amplitudes)
% 6. Count the number of peaks in the frequency ranges 
% 0-5000hz, 5000-10000Hz, 10000-22000Hz
for i=1:num_species
    for j=1:total_sample
        current_sig = all_audio(:,j,i);
        Y = fft(current_sig);
        P2 = abs(Y/length(Y));
        P1 = P2(1:length(Y)/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        
        peaks(1,j,i) = sum(P1(1:2500,1)>0.0016);
        peaks(2,j,i) = sum(P1(2500:5000,1)>0.0016);
        peaks(3,j,i) = sum(P1(5001:end,1)>0.0016);
    end
end


spec_len = size(spec_centroid,1);
mel_len = size(mel_coeff,1);
peak_len = size(peaks,1);

% create a final matrix for the classifier
% each row is a sample of a specific species
% the columns are the spectral centroid, MFC coefficients, and single-sided Amplitude peak totals
for i=1:num_species
    aname = string(filenames(i,1));
    for j=1:total_sample
        offset = (i-1)*total_sample;
        name_mat(j+offset,1) = aname;
        final_mat(j+offset,1:spec_len) = spec_centroid(:,j,i);
        next = spec_len+1;
        final_mat(j+offset,next:(next+mel_len-1)) = mel_coeff(:,j,i);
        next = next+mel_len;
        final_mat(j+offset,next:(next+peak_len-1)) = peaks(:,j,i);
    end
end

% extract the testing samples from the full data set 80-20 Rule
% use every 6th element (10 elements/species)
for i=1:num_species*10
    test_mat(i,:) = final_mat(i*6,:);
    test_name_mat(i,1) = name_mat(i*6,1);
end

% delete the test data from the training data
final_mat(6:6:end,:) = [];
name_mat(6:6:end,:) = [];

% convert the matrix to cell 
% row 1: species name
% row 2-end: audio features
[row, col] = size(final_mat);
for i=1:row
    final_cell{i,1} = name_mat(i,1);
    for j=1:col
        final_cell{i,j+1} = final_mat(i,j);
    end
end

% same as above but for the test data
[row, col] = size(test_mat);
for i=1:row
    test_cell{i,1} = test_name_mat(i,1);
    for j=1:col
        test_cell{i,j+1} = test_mat(i,j);
    end
end

% convert the cells into a table 
% better format for classifier
train_table = cell2table(final_cell);
final_cell = test_cell;
test_table = cell2table(final_cell);


