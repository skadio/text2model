% Parameters
int: max_total_units = 20;
int: min_feasibility = 5;
int: max_diff_yz = 10;

int: cost_x = 100;
int: cost_y = 200;
int: cost_z = 150;

% Variables
var 0..max_total_units: X;
var 0..max_total_units: Y;
var 0..max_total_units: Z;

var 0..(cost_x*max_total_units + cost_y*max_total_units + cost_z*max_total_units): total_cost;

% Constraints
constraint X + Y + Z <= max_total_units;
constraint 2*X + Y >= min_feasibility;
constraint abs(Y - Z) <= max_diff_yz;

constraint total_cost = cost_x*X + cost_y*Y + cost_z*Z;

% Objective
solve minimize total_cost;