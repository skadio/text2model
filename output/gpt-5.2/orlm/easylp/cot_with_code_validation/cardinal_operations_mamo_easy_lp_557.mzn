% Parameters
int: max_total = 500;
int: min_xy_sum = 200;
int: diff_yz_max = 150;

int: cost_x = 50;
int: cost_y = 30;
int: cost_z = 100;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(max_total * max(cost_x, max(cost_y, cost_z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total;
constraint 2 * X >= Y;                 % X >= Y/2
constraint abs(Y - Z) <= diff_yz_max;
constraint X + Y >= min_xy_sum;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;