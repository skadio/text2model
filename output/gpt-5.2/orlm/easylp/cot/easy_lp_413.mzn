% Parameters (with values embedded)
int: total_budget = 2000;
int: reach_rhs = 500;
int: diff_ub = 800;

int: cost_X1 = 1000;
int: cost_X2 = 500;

int: max_invest_X1 = 1500;
int: max_invest_X2 = 1000;

% Variables
var 0..max_invest_X1: X1;  % whole-number investment units in campaign X1
var 0..max_invest_X2: X2;  % whole-number investment units in campaign X2

var int: total_cost;

% Constraints
constraint X1 + X2 <= total_budget;
constraint 3 * X1 - X2 >= reach_rhs;
constraint X1 - 2 * X2 <= diff_ub;

constraint total_cost = cost_X1 * X1 + cost_X2 * X2;

% Objective
solve minimize total_cost;