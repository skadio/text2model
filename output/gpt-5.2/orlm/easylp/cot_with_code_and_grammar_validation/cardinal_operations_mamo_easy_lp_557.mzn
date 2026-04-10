% Parameters
int: max_total = 500;
int: min_xy = 200;
int: diff_yz_max = 150;

int: cost_x = 50;
int: cost_y = 30;
int: cost_z = 100;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(cost_x*max_total + cost_y*max_total + cost_z*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

% X should not be less than half of Y  => X >= Y/2  => 2X >= Y
constraint 2 * X >= Y;

% |Y - Z| <= 150
constraint abs(Y - Z) <= diff_yz_max;

% X + Y >= 200
constraint X + Y >= min_xy;

% Cost definition
constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;