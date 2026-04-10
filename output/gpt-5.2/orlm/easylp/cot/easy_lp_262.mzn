% Parameters (with values embedded)
int: max_total_hires = 100;
int: min_X = 20;
int: min_Y = 30;
int: min_Z = 10;

int: cost_X = 50000;
int: cost_Y = 60000;
int: cost_Z = 70000;

% Variables
var 0..max_total_hires: x; % hires in department X
var 0..max_total_hires: y; % hires in department Y
var 0..max_total_hires: z; % hires in department Z

var 0..(max_total_hires * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint x >= min_X;
constraint y >= min_Y;
constraint z >= min_Z;

constraint x + y + z <= max_total_hires;

constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;