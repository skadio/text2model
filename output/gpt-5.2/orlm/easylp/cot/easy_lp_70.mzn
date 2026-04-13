% Parameters (with values embedded)
int: water_per_X = 5;
int: water_per_Y = 3;
int: water_available = 100;

int: min_yield = 30;        % constraint: 2*X + Y >= 30
int: yield_coeff_X = 2;
int: yield_coeff_Y = 1;

int: cost_X = 4;
int: cost_Y = 2;

% Variables
var 0..(water_available div water_per_X): X;
var 0..(water_available div water_per_Y): Y;
var 0..(cost_X * (water_available div water_per_X) + cost_Y * (water_available div water_per_Y)): total_cost;

% Constraints
constraint water_per_X * X + water_per_Y * Y <= water_available;
constraint yield_coeff_X * X + yield_coeff_Y * Y >= min_yield;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;