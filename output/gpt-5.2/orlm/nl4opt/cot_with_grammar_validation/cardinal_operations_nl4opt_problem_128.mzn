% Parameters
int: glass_capacity = 500;
int: plastic_capacity = 750;
int: total_water = 250000;
int: min_glass = 20;
int: plastic_to_glass_ratio = 3;

% Variables
var 0..(total_water div glass_capacity): g; % number of glass bottles
var 0..(total_water div plastic_capacity): p; % number of plastic bottles

% Constraints
constraint g >= min_glass;
constraint p >= plastic_to_glass_ratio * g;
constraint glass_capacity * g + plastic_capacity * p <= total_water;

% Objective
solve maximize g + p;