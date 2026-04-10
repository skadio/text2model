% Parameters
int: total_resource_cap = 5000;
int: eff_x = 2;
int: eff_y = 3;
int: eff_min = 10000;
int: cost_x = 10;
int: cost_y = 20;

% Variables
var 0..total_resource_cap: X;
var 0..total_resource_cap: Y;
var 0..(cost_x * total_resource_cap + cost_y * total_resource_cap): total_cost;

% Constraints
constraint X + Y <= total_resource_cap;
constraint eff_x * X + eff_y * Y >= eff_min;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;