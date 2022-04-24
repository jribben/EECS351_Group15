function [ Y_flip ] = dataFlip(Y)
length = size(Y,1);
half = round(length/2);

first_half = Y(1:half);
second_half = Y(half+1:length);

Y_flip = [second_half;first_half];

end

