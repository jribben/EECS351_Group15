# EECS351_Group15
Marine Mammal Audio Classification

EECS 351 Group 15 Winter 2022

Izzi Nolan, Jason Ribbentrop, Sebastian Sulbroski

## Overview
The goal of this project is to create a robust marine mammal classifier to aid scientific research vessels in data collection of specific species. Various filters are tested (including high-pass, targeted moving average, and weiner) to increase the noise tolerance of our classifier model such that our system can be used in a variety of different enviornments. Collection and anlaysis of audio features (spectral centroid, Mel-frequency cepstrial coefficients, and single-sided amplitude spectrum peaks) is completed to provide data to train the classifier. A more in-depth description of our project can be found [here](itnolan.wix.com/mammals) 


## Features
**Filtering**
- _High Pass_: Our code makes use of the built-in Matlab filter call to create a high pass filter. The cutoff frequency of our fitler is currently set at 5000 Hz
- _Targeted Moving Average_: This filter was our own creation. Under 2000 Hz, the source signal is passed through a moving average filter. Above 2000 Hz, the signal is unaltered. The code for this can be found in the cutter.m
- _Weiner Filter_: Our implementation of the Weiner filter is sourced from Yi-Wen Chen. Their implementation is very well done and created cleaner signals than our attempt. Credit and link to source code can be found the dependicies section

**Audio Features**
- _Spectral Centroid_: The spectral centroid provides the weighted mean in the frequency spectrum. It can also be thought of as the "center of mass" within the frequency domain. We ustilized the built-in matlab command which includes a fft transformation of the audio signal.
- _Mel-frequency Cepstral Coefficients_: MFCCs provide the short-term power coefficients of the audio in the Melody scale which is logarithimic and better represents how Hz are precieved in human hearing. We utilized the Matlab mfcc command which uses several transformations including fft and cosine.
- _Single-sided Amplitude Spectrum Peaks_: Our code calculates the number of peaks above a given threshold in for 5000hz intervals. This aims to capture patterns for a given audio sound. We created our code which includes a fft transformation and manipulation of the fft to eliminate negative frequeinces. We then use our defined range to count the number of peaks. 

**Classifier**

We utilized the Classifier Learner App(CLA) within the Matlab Toolbox. Our decision to use the CLA is that it provides a graphical user interface to quickly train an algorithimm based on our training data. We can compare various classification algorithims (decision tree and support vector machines) in a much faster way than coding the vaious steps within a matlab script. Also, we can tune our algorithims, such as level of tree pruining and kernel scaling, to improve our training accuracy percentage. The CLA app also can create confusion matrices which we can use to determine the strengths and weaknesses of the current algorithim. Once we chose the best performing algorithim, it is exported to the Matlab workspace and can be called with new test data. 


## Running the Code (DEMO)
The project demo is split into 3 parts...

1. Plot Creation for Filter Analysis
2. Data Creation (Augmentation, Filtering, Audio Feature Extraction, Formatting)
3. Classifier Training and Selection
4. Classifier Testing

**Plot Creation for Filter Analysis**
1. Open demo3.m and run(1 minute to run)
2. Three plots will display. a brief description is listed below
3. Figure 1: Spectrograms for unfiltered, 5kHz High Pass, 2Khz High Pass
4. Figure 2: Spectrograms for targeted moving average
5. Figure 3: Visual of Weiner filter application

**Data Creation**
1. Open demo1.m and run (2-3 minutes to run)
2. The cutter.m is setup to apply Weiner Filter. Only the Weiner filter is applied during our demo. Follow non-Demo for different filters.
3. demo.m will pause when the test/train data is created
4. Test data is labled as test_table, Train data is labled as train_table. 80-20 rule is follwed during creation.
5. test_table is saved as Weiner_Test.mat and used during testing. They should be the equal in values. 

**Classifier Training and Selection**
1. Use of the Matlab Classification Learner App is skipped in the demo. Trained models already exist in the folder
2. Trained models are listed as Weiner_SVM.mat and Weiner_Tree.mat
3. Models for other filters exist, but are skipped for the demo

**Classifier Testing**
1. Open demo2.m and run (under 5 seconds)
2. The trained models are called with input test data Weiner_Test.mat
3. Accuracies of both models are reported in the temrinal.


## Running the Code (NON-DEMO)
The project is split into 3 parts...

1. Data Creation (Augmentation, Filtering, Audio Feature Extraction, Formatting)
2. Classifier Training and Selection
3. Classifier Testing

**Data Creation**
1. Uncomment the desired filter application (or none for unfiltered) in cutter.m
2. Choose the desired audio feature extration extract*.m (all, cent, mfcc, peaks)
3. Run whichever Matlab file you choose
4. In the Matlab workspace, test data will be labled test_table and train data will be labled trian_table

**Classifier Training and Selection**
1. Open the Classifier Learner App in Matlab 
2. Choose the train_table data from the workspace
3. Choose whichever classification algorithim you wish to analyze (All Trees and All SVM)
4. Compare training accuracies and confusion matricies 
5. Choose the desired algorithim and export it to the Matlab workspace
6. Save the Trained model to the current folder
7. NOTE: There are several existing modles that already saved to the workspace

**Classifier Testing**
1. Open test.m
2. Uncomment the code for the desired model
3. Run the file and the test accuracy will display in the terminal

## Dependicies

**Data**

All of the data for this project is sourced from Watkins Marine Mammal Sound Database, Woods Hole Oceanographic Institution and the New Bedford Whaling Museum. We appreciate and thank them for keeping the data set public for personal and academic purposes. The webiste can be found [here](https://cis.whoi.edu/science/B/whalesounds/index.cfm). Selected data is included in this repo (in folders with species name).

**Weiner Filter**

The Weiner filter used in this project (noiseReduction_YM.m/.p) was sourced from Yi-Wen Chen. The code can be found [here](https://medium.com/audio-processing-by-matlab/noise-reduction-by-wiener-filter-by-matlab-44438af83f96). The code is included in this repo.

## Additional Note 
**Whale-Dolphin Classification**

In addition to species classification, our project is also capable of classifiy in more general terms of whale and dolphin. Exported training models exists in the Whale_Dolphin_classification folder. Those models can be used by moving them to the parent directory and uncommenting code in the test.m file. To extract data that uses this format, change line 98 in extract_all.m
 
