% Parameters (with values embedded)
int: tooth_total = 2000;
int: tooth_small = 10;
int: meat_small = 12;
int: tooth_large = 15;
int: meat_large = 15;
int: min_large = 30;

% Variables
var 0..(tooth_total div tooth_small): x_small;   % number of small bones
var 0..(tooth_total div tooth_large): x_large;   % number of large bones

% Constraints
constraint tooth_small * x_small + tooth_large * x_large <= tooth_total;
constraint x_large >= min_large;

% at least 50% of bones are small: x_small >= 0.5*(x_small + x_large) -> x_small >= x_large
constraint x_small >= x_large;

% Objective
var int: total_meat = meat_small * x_small + meat_large * x_large;
solve minimize total_meat;