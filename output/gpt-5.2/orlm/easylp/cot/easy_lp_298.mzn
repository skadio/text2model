% Parameters (with values embedded)
int: max_total_resources = 100;
int: min_score_YZ = 50;
int: max_XZ = 80;

int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 1;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var 0..max_total_resources: Z;

var 0..(cost_X*max_total_resources + cost_Y*max_total_resources + cost_Z*max_total_resources): total_cost;

% Constraints
constraint X + Y + Z <= max_total_resources;
constraint 2*Y + Z >= min_score_YZ;
constraint X + Z <= max_XZ;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;