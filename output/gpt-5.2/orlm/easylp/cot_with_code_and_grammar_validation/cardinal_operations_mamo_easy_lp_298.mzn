% Parameters
int: max_total_resources = 100;
int: min_env_score = 50;
int: max_xz_resources = 80;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 1;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var 0..max_total_resources: Z;

var 0..(cost_x*max_total_resources + cost_y*max_total_resources + cost_z*max_total_resources): total_cost;

% Constraints
constraint X + Y + Z <= max_total_resources;
constraint 2*Y + Z >= min_env_score;
constraint X + Z <= max_xz_resources;

constraint total_cost = cost_x*X + cost_y*Y + cost_z*Z;

% Objective
solve minimize total_cost;