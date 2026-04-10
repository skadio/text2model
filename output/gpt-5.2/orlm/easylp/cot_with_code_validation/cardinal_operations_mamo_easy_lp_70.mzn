% Parameters
int: water_per_X = 5;
int: water_per_Y = 3;
int: water_available = 100;

int: balance_X_coeff = 2;
int: balance_Y_coeff = 1;
int: balance_min = 30;

int: cost_per_X = 4;
int: cost_per_Y = 2;

% Variables
var 0..water_available div water_per_X: X;
var 0..water_available div water_per_Y: Y;
var 0..(cost_per_X * (water_available div water_per_X) + cost_per_Y * (water_available div water_per_Y)): total_cost;

% Constraints
constraint water_per_X * X + water_per_Y * Y <= water_available;
constraint balance_X_coeff * X + balance_Y_coeff * Y >= balance_min;
constraint total_cost = cost_per_X * X + cost_per_Y * Y;

% Objective
solve minimize total_cost;