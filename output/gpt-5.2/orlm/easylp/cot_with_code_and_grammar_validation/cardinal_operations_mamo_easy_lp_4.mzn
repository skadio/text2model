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
var 0..max_budget: x; % budget allocated to channel X (whole dollars)
var 0..max_budget: y; % budget allocated to channel Y (whole dollars)

% Constraints
constraint x + y <= max_budget;

constraint eff_x * x + eff_y * y >= min_effectiveness;

constraint bal_x * x + bal_y * y <= max_balance;

% Objective
solve minimize cost_x * x + cost_y * y;