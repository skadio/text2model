% Parameters
int: cap_large = 2000;
int: cap_small = 800;
int: pol_large = 20;
int: pol_small = 15;

int: max_large = 7;
int: demand = 20000;

% Variables
var 0..max_large: x_large;
var 0..demand: x_small;

% Constraints
constraint cap_large * x_large + cap_small * x_small >= demand;

constraint x_large <= max_large;

% At least 40% of total trips are small:
% x_small >= 0.4 * (x_large + x_small)  <=>  3*x_small >= 2*x_large
constraint 3 * x_small >= 2 * x_large;

% Objective
solve minimize pol_large * x_large + pol_small * x_small;