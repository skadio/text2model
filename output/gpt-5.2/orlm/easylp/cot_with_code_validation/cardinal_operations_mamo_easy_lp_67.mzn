% Parameters
int: max_acres = 1000;
int: fertility_min = 800;
int: degradation_max = 500;

int: wheat_cost = 4;
int: corn_cost = 3;

% Variables
var 0..max_acres: wheat;
var 0..max_acres: corn;
var 0..(wheat_cost*max_acres + corn_cost*max_acres): total_cost;

% Constraints
constraint wheat + corn <= max_acres;
constraint 2*wheat + 4*corn >= fertility_min;
constraint 3*wheat - corn <= degradation_max;

constraint total_cost = wheat_cost*wheat + corn_cost*corn;

% Objective
solve minimize total_cost;