% Parameters (with values embedded)
int: glass_ml = 500;
int: plastic_ml = 750;
int: total_water_ml = 250000;
int: min_glass = 20;
int: plastic_ratio = 3;

% Variables
var 0..(total_water_ml div glass_ml): g; % number of glass bottles
var 0..(total_water_ml div plastic_ml): p; % number of plastic bottles

% Constraints
constraint g >= min_glass;
constraint p >= plastic_ratio * g;
constraint glass_ml * g + plastic_ml * p <= total_water_ml;

% Objective
solve maximize g + p;