% Parameters
int: c1 = 50;
int: c2 = 75;
int: c3 = 120;

int: total_cap = 500;
int: eff_min = 1000;
int: diff_max = 300;

% Variables
var 0..total_cap: x1;
var 0..total_cap: x2;
var 0..total_cap: x3;

var 0..(c1*total_cap + c2*total_cap + c3*total_cap): total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_cap;

constraint 5*x1 + 10*x2 >= eff_min;

% 2.5*x3 - x1 <= 300  <=>  5*x3 - 2*x1 <= 600
constraint 5*x3 - 2*x1 <= 2*diff_max;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;