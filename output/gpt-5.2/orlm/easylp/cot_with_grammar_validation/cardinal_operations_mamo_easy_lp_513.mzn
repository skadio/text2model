% Parameters
int: cost_x1 = 50;
int: cost_x2 = 75;
int: cost_x3 = 120;

int: total_alloc_max = 500;

int: eff_x1 = 5;
int: eff_x2 = 10;
int: eff_min = 1000;

int: diff_num_x3 = 5;   % represents 2.5 * x3 = (5/2) * x3
int: diff_den_x3 = 2;
int: diff_x1_coeff = 1;
int: diff_max = 300;

% Resource allocation bounds (not specified explicitly; assume nonnegative)
int: x1_lb = 0;
int: x2_lb = 0;
int: x3_lb = 0;
int: x1_ub = total_alloc_max;
int: x2_ub = total_alloc_max;
int: x3_ub = total_alloc_max;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;

var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub): total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_alloc_max;

constraint eff_x1 * x1 + eff_x2 * x2 >= eff_min;

% (5/2)*x3 - x1 <= 300  ->  5*x3 - 2*x1 <= 600
constraint diff_num_x3 * x3 - (diff_den_x3 * diff_x1_coeff) * x1 <= diff_den_x3 * diff_max;

constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;