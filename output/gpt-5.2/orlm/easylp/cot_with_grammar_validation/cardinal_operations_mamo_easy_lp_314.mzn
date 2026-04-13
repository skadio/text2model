% Parameters
int: max_resources = 100;
int: eff_required = 350;

int: eff_X = 5;
int: eff_Y = 3;
int: eff_Z = 7;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

% Variables
var 0..max_resources: x;
var 0..max_resources: y;
var 0..max_resources: z;

var 0..(cost_X*max_resources + cost_Y*max_resources + cost_Z*max_resources): total_cost;

% Constraints
constraint x + y + z <= max_resources;

constraint eff_X*x + eff_Y*y + eff_Z*z >= eff_required;

constraint 2*x + 2*y - z <= 0;

constraint total_cost = cost_X*x + cost_Y*y + cost_Z*z;

% Objective
solve minimize total_cost;