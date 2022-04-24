% Test Classifier

clear all;
clc;

% load the trained model and test data table
% then call the predict function for the model with the data table
% Several options are listed below. Uncomment the desired filter/algorithim
% combination
% NOTE: Only uncomment/comment one set at time. 

% UNFILTERED

% Tree
load('Unfiltered_Tree.mat');
load('Unfiltered_Test.mat');
predictions = Unfiltered_Tree.predictFcn(test_table);

% SVM
% load('Unfiltered_SVM.mat');
% load('Unfiltered_Test.mat');
% predictions = Unfiltered_SVM.predictFcn(test_table);


% HIGHPASS FILTER 

% Tree
% load('HP_Tree.mat');
% load('HP_Test.mat');
% predictions = HP_Tree.predictFcn(test_table);

% SVM
% load('HP_SVM.mat');
% load('HP_Test.mat');
% predictions = HP_SVM.predictFcn(test_table);



% TARGETED MOVING AVERAGE FILTER

% Tree
% load('TMA_Tree.mat');
% load('TMA_Test.mat');
% predictions = TMA_Tree.predictFcn(test_table);

% SVM
% load('TMA_SVM.mat');
% load('TMA_Test.mat');
% predictions = TMA_SVM.predictFcn(test_table);


% WEINER FILTER

% Tree
% load('Weiner_Tree.mat');
% load('Weiner_Test.mat');
% predictions = Weiner_Tree.predictFcn(test_table);

% SVM
% load('Weiner_SVM.mat');
% load('Weiner_Test.mat');
% predictions = Weiner_SVM.predictFcn(test_table);



% compare the predictions and real values
% keep count of how many are correct
% Keep the following lines uncommented
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
    
