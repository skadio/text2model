% Parameters
int: max_projects = 50;
int: min_effectiveness = 150;
int: max_diff_xy = 10;

int: eff_x = 3;
int: eff_y = 4;
int: eff_z = 5;

int: cost_x = 2000;
int: cost_y = 3000;
int: cost_z = 4000;

% Variables
var 0..max_projects: x;
var 0..max_projects: y;
var 0..max_projects: z;

var 0..(max_projects * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z <= max_projects;

constraint eff_x * x + eff_y * y + eff_z * z >= min_effectiveness;

constraint abs(x - y) <= max_diff_xy;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;