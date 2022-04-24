clc;
% For sake of time, classification model is already done

% load the trained model and test data table
% then call the predict function for the model with the data table

% WEINER FILTER

% Tree Model
load('Weiner_Tree.mat');
load('Weiner_Test.mat');
predictions = Weiner_Tree.predictFcn(test_table);

% compare the predictions and real values
% keep count of how many are correct
% Keep the following lines uncommented
[rows cols] = size(test_table);
tree_num_correct = 0;
for i=1:rows
    real = test_table{i,1};
    prediction = predictions{i,1};
    if real==prediction
        tree_num_correct = tree_num_correct + 1; 
    end
end

% SVM Model
load('Weiner_SVM.mat');
load('Weiner_Test.mat');
predictions = Weiner_SVM.predictFcn(test_table);

svm_num_correct = 0;
for i=1:rows
    real = test_table{i,1};
    prediction = predictions{i,1};
    if real==prediction
        svm_num_correct = svm_num_correct + 1; 
    end
end

% calculate and display the accuracy precentages
tree_accuracy = (tree_num_correct/rows)*100;
svm_accuracy = (svm_num_correct/rows)*100;
fprintf('Accuracy of Weiner Filter with Decision Tree: %f\n',tree_accuracy);
fprintf('Accuracy of Weiner Filter with SVM: %f\n',svm_accuracy);
