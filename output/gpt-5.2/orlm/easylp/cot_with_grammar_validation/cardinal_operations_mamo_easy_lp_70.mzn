% Parameters
int: water_per_x = 5;
int: water_per_y = 3;
int: water_limit = 100;

int: balance_x_coeff = 2;
int: balance_y_coeff = 1;
int: balance_min = 30;

int: cost_x = 4;
int: cost_y = 2;

% Variables
var 0..(water_limit div water_per_x): x;
var 0..(water_limit div water_per_y): y;
var 0..(cost_x*(water_limit div water_per_x) + cost_y*(water_limit div water_per_y)): total_cost;

% Constraints
constraint water_per_x * x + water_per_y * y <= water_limit;

constraint balance_x_coeff * x + balance_y_coeff * y >= balance_min;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;