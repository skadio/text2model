% Parameters
int: max_budget = 5000;
int: min_effectiveness = 12000;
int: max_balance = 10000;

int: eff_x = 3;
int: eff_y = 4;

int: bal_x = 5;
int: bal_y = -2;

int: cost_x = 200;
int: cost_y = 150;

% Variables
var 0..max_budget: x; % budget for channel X (whole dollars)
var 0..max_budget: y; % budget for channel Y (whole dollars)

var 0..(cost_x * max_budget + cost_y * max_budget): total_cost;

% Constraints
constraint x + y <= max_budget;

constraint eff_x * x + eff_y * y >= min_effectiveness;

constraint bal_x * x + bal_y * y <= max_balance;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;