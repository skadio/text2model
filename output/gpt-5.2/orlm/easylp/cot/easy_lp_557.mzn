% Parameters (with values embedded)
int: max_total_packages = 500;
int: min_XY_sum = 200;
int: max_YZ_diff = 150;

int: cost_X = 50;
int: cost_Y = 30;
int: cost_Z = 100;

% Variables
var 0..max_total_packages: X;
var 0..max_total_packages: Y;
var 0..max_total_packages: Z;

var 0..(cost_X*max_total_packages + cost_Y*max_total_packages + cost_Z*max_total_packages): total_cost;

% Constraints
constraint X + Y + Z <= max_total_packages;

% X should not be less than half of Y: X >= Y/2  <=>  2X >= Y
constraint 2 * X >= Y;

% |Y - Z| <= 150
constraint abs(Y - Z) <= max_YZ_diff;

% X + Y >= 200
constraint X + Y >= min_XY_sum;

% Total cost definition
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;