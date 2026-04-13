% Parameters (with values embedded)
int: min_inventory_score = 10;          % x + 3y >= 10
int: max_storage_limit = 15;            % 2x + y <= 15
int: cost_x = 4;
int: cost_y = 5;

% Variables
var 0..15: x;                           % integer units of category X
var 0..15: y;                           % integer units of category Y
var 0..(cost_x*15 + cost_y*15): total_cost;

% Constraints
constraint x + 3*y >= min_inventory_score;
constraint 2*x + y <= max_storage_limit;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;