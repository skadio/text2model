% Parameters
int: total_cap = 100;
int: min_diff_xy = 10;
int: cap_yz = 70;

int: cost_x = 5;
int: cost_y = 3;
int: cost_z = 4;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

var 0..(cost_x*total_cap + cost_y*total_cap + cost_z*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;

constraint X >= Y + min_diff_xy;

constraint Y + Z <= cap_yz;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;