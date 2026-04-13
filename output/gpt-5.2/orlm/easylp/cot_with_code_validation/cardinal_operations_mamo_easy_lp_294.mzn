% Parameters
int: total_funding = 100;
int: min_x = 30;
int: min_y = 20;
int: min_z = 10;
int: cost_x = 20;
int: cost_y = 15;
int: cost_z = 10;

% Variables
var 0..total_funding: x;
var 0..total_funding: y;
var 0..total_funding: z;
var 0..(total_funding * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x >= min_x;
constraint y >= min_y;
constraint z >= min_z;

constraint x + y + z <= total_funding;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;