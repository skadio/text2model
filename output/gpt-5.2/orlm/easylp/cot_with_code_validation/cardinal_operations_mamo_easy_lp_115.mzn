% Parameters
int: max_budget = 100;
int: min_effectiveness = 150;
int: eff_x = 2;
int: eff_y = 3;
int: cost_x = 20;
int: cost_y = 30;

% Variables
var 0..max_budget: x; % budget allocated to campaign X (whole dollars)
var 0..max_budget: y; % budget allocated to campaign Y (whole dollars)
var 0..(max_budget * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x + y <= max_budget;
constraint eff_x * x + eff_y * y >= min_effectiveness;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;