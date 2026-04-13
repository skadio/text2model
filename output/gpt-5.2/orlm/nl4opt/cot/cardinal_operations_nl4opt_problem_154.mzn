% Parameters (with values embedded)
int: packages_regular = 500;
int: packages_hybrid  = 300;
int: pollutants_regular = 200;
int: pollutants_hybrid  = 100;

int: max_pollutants = 7000;
int: min_packages  = 20000;

% Variables
var 0..1000: x_regular; % number of regular vans
var 0..1000: x_hybrid;  % number of hybrid vans

% Constraints
constraint packages_regular * x_regular + packages_hybrid * x_hybrid >= min_packages;
constraint pollutants_regular * x_regular + pollutants_hybrid * x_hybrid <= max_pollutants;

% Objective
solve minimize x_regular + x_hybrid;