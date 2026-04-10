% Parameters
int: cost_X = 4;
int: cost_Y = 5;

int: cap_coeff_X = 2;
int: cap_coeff_Y = 3;
int: cap_rhs = 1000;

int: dem_coeff_X = 3;
int: dem_coeff_Y = 2;
int: dem_rhs = 800;

% Variables
var 0..cap_rhs div cap_coeff_X: x;
var 0..cap_rhs div cap_coeff_Y: y;
var 0..(cost_X*(cap_rhs div cap_coeff_X) + cost_Y*(cap_rhs div cap_coeff_Y)): total_cost;

% Constraints
constraint cap_coeff_X * x + cap_coeff_Y * y <= cap_rhs;
constraint dem_coeff_X * x + dem_coeff_Y * y >= dem_rhs;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;