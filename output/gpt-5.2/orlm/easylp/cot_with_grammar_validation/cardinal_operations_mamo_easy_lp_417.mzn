% Parameters
int: max_budget = 5000;
int: eff_req = 2000;
int: diff_limit = 1000;

int: cost_x = 1000;
int: cost_y = 1500;

% Variables
var 0..max_budget: x;
var 0..max_budget: y;

var 0..(cost_x * max_budget + cost_y * max_budget): total_cost;

% Constraints
constraint x + y <= max_budget;

constraint 3 * x - 2 * y >= eff_req;

constraint abs(x - y) <= diff_limit;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;