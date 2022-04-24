% Test Classifier

clear all;
clc;

% load the trained model and test data table
% then call the predict function for the model with the data table
% NOTE: Can only call one at a time

% UNFILTERED Whale-Dolphin
% load('WD_Unfiltered_All.mat');
% load('testData_WD_Unfiltered.mat');
% predictions = WD_Unfiltered_All.predictFcn(test_table);

% HIGH-PASS Whale-Dolphin
% load('WD_HP_All.mat');
% load('testData_WD_HP.mat');
% predictions = WD_HP_All.predictFcn(test_table);



% UNFILTERED All 10

% All 3 features used
% load('Unfiltered_All.mat');
% load('testData_Unfiltered_all.mat');
% predictions = trainedModle_Unfitered_All.predictFcn(test_table);

% Only spectral centroid feature
% load('Unfiltered_Cent.mat');
% load('testData_Unfiltered_cent.mat');
% predictions = Unfiltered_Cent.predictFcn(test_table);

% Only Mfcc feature
% load('Unfiltered_Mfcc.mat');
% load('testData_Unfiltered_mfcc.mat');
% predictions = Unfiltered_Mfcc.predictFcn(test_table);

% Only single-sided amplitude spectrum feature
% load('Unfiltered_Peaks.mat');
% load('testData_Unfiltered_peaks.mat');
% predictions = Unfiltered_Peaks.predictFcn(test_table);



% HIGHPASS FILTER (5000Hz) All 10

% All 3 features used
% load('HP_All.mat');
% load('testData_HP_all.mat');
% predictions = HP_All.predictFcn(test_table);

% Only spectral centroid feature
% load('HP_Cent.mat');
% load('testData_HP_cent.mat');
% predictions = HP_Cent.predictFcn(test_table);

% Only Mfcc feature
% load('HP_Mfcc.mat');
% load('testData_HP_mfcc.mat');
% predictions = HP_Mfcc.predictFcn(test_table);

% Only single-sided amplitude spectrum feature
% load('HP_Peaks.mat');
% load('testData_HP_peaks.mat');
% predictions = HP_peaks.predictFcn(test_table);

% MEGA FILTER
% All
% load('Mega_All.mat');
% load('testData_Mega_all.mat');
% predictions = Mega_All.predictFcn(test_table);

% Centroid
% load('Mega_Cent.mat');
% load('testData_Mega_cent.mat');
% predictions = Mega_Cent.predictFcn(test_table);

% Mfcc
% load('Mega_Mfcc.mat');
% load('testData_Mega_mfcc.mat');
% predictions = Mega_Mfcc.predictFcn(test_table);

% Peaks
load('Mega_Peaks.mat');
load('testData_Mega_peaks.mat');
predictions = Mega_Peaks.predictFcn(test_table);

% compare the predictions and real values
% keep count of how many are correct
[rows cols] = size(test_table);
num_correct = 0;
for i=1:rows
    real = test_table{i,1};
    prediction = predictions{i,1};
    if real==prediction
        num_correct = num_correct + 1; 
    end
end

% calculate and display the accuracy precentage
accuracy = (num_correct/rows)*100;
disp(accuracy);
    
