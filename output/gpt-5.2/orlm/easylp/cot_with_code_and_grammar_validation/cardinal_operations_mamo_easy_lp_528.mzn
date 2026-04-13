% Parameters
int: total_max = 1000;
int: x_at_least_y_plus = 50;
int: zx_diff_max = 200;
int: yz_min = 400;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 4;

% Variables
var 0..total_max: X;
var 0..total_max: Y;
var 0..total_max: Z;

var 0..(cost_x*total_max + cost_y*total_max + cost_z*total_max): total_cost;

% Constraints
constraint X + Y + Z <= total_max;
constraint X >= Y + x_at_least_y_plus;
constraint abs(Z - X) <= zx_diff_max;
constraint Y + Z >= yz_min;

constraint total_cost = cost_x*X + cost_y*Y + cost_z*Z;

% Objective
solve minimize total_cost;