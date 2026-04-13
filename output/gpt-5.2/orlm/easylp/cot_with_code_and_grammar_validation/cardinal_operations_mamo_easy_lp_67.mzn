% Parameters
int: max_acres = 1000;
int: fertility_min = 800;
int: degradation_max = 500;

int: cost_wheat = 4;
int: cost_corn  = 3;

% Variables
var 0..max_acres: wheat;
var 0..max_acres: corn;

var 0..(cost_wheat*max_acres + cost_corn*max_acres): total_cost;

% Constraints
constraint wheat + corn <= max_acres;

constraint 2*wheat + 4*corn >= fertility_min;

constraint 3*wheat - corn <= degradation_max;

constraint total_cost = cost_wheat*wheat + cost_corn*corn;

% Objective
solve minimize total_cost;