% Parameters
int: cost_x1 = 5;
int: cost_x2 = 10;
int: cost_x3 = 20;
int: cost_x4 = 25;

int: max_x1_x2 = 100;
int: max_x3_x4_total = 200;

int: min_mix = 50;     % x1 - 2*x2 + x3 >= 50
int: max_diff = 70;    % x1 - x2 - x3 <= 70

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;

% For every 2 units of x3, 3 units of x4 can be made, with a max limit of 200 units total
constraint 3 * x3 = 2 * x4;
constraint x3 + x4 <= max_x3_x4_total;

constraint x1 - 2 * x2 + x3 >= min_mix;

constraint x1 - x2 - x3 <= max_diff;

% Variable bounds tightening implied by constraints (ensure non-negativity already in domains)
constraint x1 <= max_x1_x2;
constraint x2 <= max_x1_x2;
constraint x3 <= max_x3_x4_total;
constraint x4 <= max_x3_x4_total;

% Objective
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

solve minimize total_cost;