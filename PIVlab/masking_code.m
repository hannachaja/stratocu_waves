% Load .mat file containing values of the variable of interest
data = load('div.mat');

% Access the variable to be masked
div = data.divergence;

% Create mask(s) for values that are outliers (this will return a logical array of
% true/false satisfying the mask
divmask1 = div > 0.1;
divmask2 = div < -0.1;

% Apply the mask!! (set masked values to 0, NaN, or any other placeholder value)
div(divmask1)=0;
div(divmask2)=0;

% Update the variable in the structure
data.divergence = div;

% Save the modified data to a new .mat file
save('div_masked.mat', '-struct', 'data')