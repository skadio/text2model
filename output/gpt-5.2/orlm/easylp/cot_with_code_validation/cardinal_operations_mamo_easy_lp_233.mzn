% Parameters
int: cost_wheat = 10;
int: cost_corn = 15;
int: cost_soy = 20;

int: max_wheat = 400;
int: max_corn  = 200;
int: max_soy   = 300;

int: limit_2w_plus_c = 500;
int: min_w_plus_s = 300;
int: max_diff_c_s = 100;

% Variables
var 0..max_wheat: wheat;
var 0..max_corn:  corn;
var 0..max_soy:   soy;

var int: total_cost;

% Constraints
constraint 2 * wheat + corn <= limit_2w_plus_c;
constraint wheat + soy >= min_w_plus_s;
constraint abs(corn - soy) <= max_diff_c_s;

constraint total_cost = cost_wheat * wheat + cost_corn * corn + cost_soy * soy;

% Objective
solve minimize total_cost;