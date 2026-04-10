% Parameters
int: total_cap = 1000;
int: x_min_more_than_y = 50;
int: zx_diff_max = 200;
int: yz_min_sum = 400;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 4;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

var 0..(cost_x*total_cap + cost_y*total_cap + cost_z*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;

constraint X >= Y + x_min_more_than_y;

constraint abs(Z - X) <= zx_diff_max;

constraint Y + Z >= yz_min_sum;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;