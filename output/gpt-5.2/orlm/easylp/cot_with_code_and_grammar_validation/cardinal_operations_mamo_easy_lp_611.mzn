% Parameters
int: max_wheat_corn = 500;
int: max_rice_barley = 600;

int: wheat_min_minus_rice = 100;
int: corn_min_minus_barley = 200;

int: cost_wheat = 10;
int: cost_corn = 20;
int: cost_rice = 30;
int: cost_barley = 40;

% Variables
var 0..max_wheat_corn: wheat;
var 0..max_wheat_corn: corn;
var 0..max_rice_barley: rice;
var 0..max_rice_barley: barley;

var 0..(cost_wheat*max_wheat_corn + cost_corn*max_wheat_corn + cost_rice*max_rice_barley + cost_barley*max_rice_barley): total_cost;

% Constraints
constraint wheat + corn <= max_wheat_corn;
constraint rice + barley <= max_rice_barley;

constraint wheat >= rice + wheat_min_minus_rice;
constraint corn >= barley + corn_min_minus_barley;

constraint total_cost = cost_wheat*wheat + cost_corn*corn + cost_rice*rice + cost_barley*barley;

% Objective
solve minimize total_cost;