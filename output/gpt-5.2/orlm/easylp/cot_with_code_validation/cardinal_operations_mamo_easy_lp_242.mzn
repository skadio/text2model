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
var 0..max_projects: X;
var 0..max_projects: Y;
var 0..max_projects: Z;

var 0..(max_projects * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint X + Y + Z <= max_projects;

constraint eff_x * X + eff_y * Y + eff_z * Z >= min_effectiveness;

constraint abs(X - Y) <= max_diff_xy;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;