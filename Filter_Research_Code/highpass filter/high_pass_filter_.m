close all; clear all; clc;

% read in .wav audio file
[audio_in,fs] = audioread("audio_samples/whale_pilot.wav");

% apply "highpass" filter to audio_in
audio_filtered = highpass(audio_in, 5000, fs);