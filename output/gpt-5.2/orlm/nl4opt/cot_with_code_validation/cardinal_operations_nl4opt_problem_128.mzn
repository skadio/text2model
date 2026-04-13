% Parameters
int: cap_glass = 500;
int: cap_plastic = 750;
int: total_water = 250000;
int: plastic_ratio = 3;
int: min_glass = 20;

% Variables
var 0..(total_water div cap_glass): g; % number of glass bottles
var 0..(total_water div cap_plastic): p; % number of plastic bottles

% Constraints
constraint g >= min_glass;
constraint p >= plastic_ratio * g;
constraint cap_glass * g + cap_plastic * p <= total_water;

% Objective
solve maximize g + p;