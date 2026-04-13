% Parameters
int: total_budget = 100;
int: eff_min = 150;

int: eff_x = 2;
int: eff_y = 3;

int: cost_x = 20;
int: cost_y = 30;

% Variables
var 0..total_budget: x;
var 0..total_budget: y;
var 0..(cost_x * total_budget + cost_y * total_budget): total_cost;

% Constraints
constraint x + y <= total_budget;
constraint eff_x * x + eff_y * y >= eff_min;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;