% Parameters
int: tooth_total = 2000;
int: tooth_small = 10;
int: tooth_large = 15;
int: meat_small = 12;
int: meat_large = 15;
int: min_large = 30;
int: min_small_pct = 50; % at least 50% small

% Variables
var 0..(tooth_total div tooth_small): x_small;
var 0..(tooth_total div tooth_large): x_large;

% Constraints
constraint tooth_small * x_small + tooth_large * x_large <= tooth_total;
constraint x_large >= min_large;
constraint 100 * x_small >= min_small_pct * (x_small + x_large);

% Objective
solve minimize meat_small * x_small + meat_large * x_large;