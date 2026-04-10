% Parameters
int: total_budget = 2000;
int: reach_rhs = 500;
int: diff_ub = 800;

int: cost_x1 = 1000;
int: cost_x2 = 500;

int: max_spend_x1 = 1500;
int: max_spend_x2 = 1000;

% Variables
var 0..max_spend_x1: x1;  % dollars allocated to campaign X1 (integer dollars)
var 0..max_spend_x2: x2;  % dollars allocated to campaign X2 (integer dollars)

var 0..(cost_x1*max_spend_x1 + cost_x2*max_spend_x2): total_cost;

% Constraints
constraint x1 + x2 <= total_budget;

constraint 3*x1 - x2 >= reach_rhs;

constraint x1 - 2*x2 <= diff_ub;

% indivisible investments: x1 in multiples of 1000, x2 in multiples of 500
constraint x1 mod 1000 = 0;
constraint x2 mod 500 = 0;

constraint total_cost = cost_x1*x1 + cost_x2*x2;

% Objective
solve minimize total_cost;