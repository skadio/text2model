% Parameters
int: cost_wheat = 20;
int: cost_corn  = 30;
int: cost_soy   = 10;

int: max_wheat_corn = 200;
int: min_rotation   = 150;
int: max_diff_corn_soy = 100;

int: max_acres = 1000;

% Variables
var 0..max_acres: wheat;
var 0..max_acres: corn;
var 0..max_acres: soy;

var 0..(cost_wheat*max_acres + cost_corn*max_acres + cost_soy*max_acres): total_cost;

% Constraints
constraint wheat + corn <= max_wheat_corn;

constraint 2*wheat + soy >= min_rotation;

constraint abs(corn - soy) <= max_diff_corn_soy;

constraint total_cost = cost_wheat*wheat + cost_corn*corn + cost_soy*soy;

% Objective
solve minimize total_cost;