% Parameters
int: cost_fertilizer = 5;
int: cost_seeds = 10;
int: total_units = 500;

int: a1 = 2;  % coefficient for fertilizer in constraint 1
int: b1 = 3;  % coefficient for seeds in constraint 1
int: rhs1 = 1000;

int: a2 = 4;  % coefficient for fertilizer in constraint 2
int: b2 = 1;  % coefficient for seeds in constraint 2
int: rhs2 = 200;

% Variables
var 0..total_units: fertilizer;
var 0..total_units: seeds;

var 0..(cost_fertilizer*total_units + cost_seeds*total_units): total_cost;

% Constraints
constraint fertilizer + seeds = total_units;

constraint a1 * fertilizer + b1 * seeds <= rhs1;

constraint a2 * fertilizer - b2 * seeds >= rhs2;

constraint total_cost = cost_fertilizer * fertilizer + cost_seeds * seeds;

% Objective
solve minimize total_cost;