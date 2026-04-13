% Parameters
int: cost_wheat = 20;
int: cost_corn = 30;
int: cost_soy = 10;

int: max_wheat_corn = 200;
int: min_2wheat_plus_soy = 150;
int: max_diff_corn_soy = 100;

% Variables
var 0..max_wheat_corn: wheat;
var 0..max_wheat_corn: corn;
var 0..max_wheat_corn: soy;

var 0..(cost_wheat*max_wheat_corn + cost_corn*max_wheat_corn + cost_soy*max_wheat_corn): total_cost;

% Constraints
constraint wheat + corn <= max_wheat_corn;
constraint 2*wheat + soy >= min_2wheat_plus_soy;
constraint abs(corn - soy) <= max_diff_corn_soy;

constraint total_cost = cost_wheat*wheat + cost_corn*corn + cost_soy*soy;

% Objective
solve minimize total_cost;