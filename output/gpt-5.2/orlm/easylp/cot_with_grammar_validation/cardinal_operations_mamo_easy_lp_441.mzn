% Parameters
int: cost_X = 20;
int: cost_Y = 30;

int: max_total_inventory = 500;
int: min_effect = 1000;

int: effect_X = 3;
int: effect_Y = 2;

int: diff_X = 4;
int: diff_limit = 600;

int: max_X = 400;
int: max_Y = 300;

% Variables
var 0..max_X: x;
var 0..max_Y: y;

var 0..(cost_X*max_X + cost_Y*max_Y): total_cost;

% Constraints
constraint x + y <= max_total_inventory;

constraint effect_X*x + effect_Y*y >= min_effect;

constraint diff_X*x - y <= diff_limit;

constraint total_cost = cost_X*x + cost_Y*y;

% Objective
solve minimize total_cost;