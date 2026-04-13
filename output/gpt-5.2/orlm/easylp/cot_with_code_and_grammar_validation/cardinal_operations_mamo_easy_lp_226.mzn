% Parameters
int: cost_x1 = 3;
int: cost_x2 = 2;
int: cost_x3 = 5;

int: max_total = 1000;
int: min_expr_2x1_3x3 = 500;
int: max_expr_4x2_x3 = 1200;

int: x1_ub = 400;
int: x2_ub = 300;
int: x3_ub = 600;

% Variables
var 0..x1_ub: x1;
var 0..x2_ub: x2;
var 0..x3_ub: x3;

var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub): total_cost;

% Constraints
constraint x1 + x2 + x3 <= max_total;
constraint 2*x1 - 3*x3 >= min_expr_2x1_3x3;
constraint 4*x2 + x3 <= max_expr_4x2_x3;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;