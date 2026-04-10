% Parameters (with values embedded)
int: max_land_x1x2 = 1000;
int: min_diversity = 500;
int: max_diff_x1x4 = 200;

int: c1 = 50;
int: c2 = 30;
int: c3 = 20;
int: c4 = 10;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var 0..(c1*1000 + c2*1000 + c3*1000 + c4*1000): total_cost;

% Constraints
constraint x1 + x2 <= max_land_x1x2;
constraint 2*x3 + 3*x4 >= min_diversity;
constraint abs(x1 - x4) <= max_diff_x1x4;
constraint x3 >= 2*x2;  % (1/2)*x3 >= x2  <=>  x3 >= 2*x2

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;