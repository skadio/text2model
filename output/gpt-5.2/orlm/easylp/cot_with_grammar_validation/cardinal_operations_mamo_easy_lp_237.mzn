% Parameters
int: cost_wheat = 5;
int: cost_corn = 4;
int: cost_soy = 6;

int: max_2w_plus_c = 50;
int: max_w_plus_3s = 60;
int: min_c_plus_s = 30;

% Variables
var 0..max_2w_plus_c: wheat;
var 0..max_2w_plus_c: corn;
var 0..max_w_plus_3s: soy;

var 0..(cost_wheat*max_2w_plus_c + cost_corn*max_2w_plus_c + cost_soy*max_w_plus_3s): total_cost;

% Constraints
constraint 2*wheat + corn <= max_2w_plus_c;
constraint wheat + 3*soy <= max_w_plus_3s;
constraint corn + soy >= min_c_plus_s;

constraint total_cost = cost_wheat*wheat + cost_corn*corn + cost_soy*soy;

% Objective
solve minimize total_cost;