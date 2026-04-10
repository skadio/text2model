% Parameters
int: cost_wheat = 10;
int: cost_corn = 15;
int: cost_soy = 20;

int: max_wheat = 400;
int: max_corn  = 200;
int: max_soy   = 300;

int: limit_twice_wheat_plus_corn = 500;
int: min_wheat_plus_soy = 300;
int: max_diff_corn_soy = 100;

% Variables
var 0..max_wheat: wheat;
var 0..max_corn:  corn;
var 0..max_soy:   soy;

var 0..(cost_wheat*max_wheat + cost_corn*max_corn + cost_soy*max_soy): total_cost;

% Constraints
constraint 2*wheat + corn <= limit_twice_wheat_plus_corn;
constraint wheat + soy >= min_wheat_plus_soy;
constraint abs(corn - soy) <= max_diff_corn_soy;

constraint total_cost = cost_wheat*wheat + cost_corn*corn + cost_soy*soy;

% Objective
solve minimize total_cost;