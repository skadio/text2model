% Parameters
int: max_budget = 1000;
int: min_effect = 2000;
int: eff_x = 2;
int: eff_y = 3;
int: cost_x = 10;
int: cost_y = 20;

% Variables
var 0..max_budget: X;
var 0..max_budget: Y;
var 0..(cost_x*max_budget + cost_y*max_budget): total_cost;

% Constraints
constraint X + Y <= max_budget;
constraint eff_x * X + eff_y * Y >= min_effect;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;