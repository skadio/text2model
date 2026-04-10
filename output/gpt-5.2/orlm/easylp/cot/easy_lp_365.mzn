% Parameters (with values embedded)
int: max_wheat_corn = 50;
int: max_rice_soy = 30;
int: min_wheat_rice = 20;
int: min_corn_soy = 15;

int: cost_wheat = 4;
int: cost_corn = 3;
int: cost_rice = 2;
int: cost_soy = 1;

% Variables
var 0..max_wheat_corn: wheat;
var 0..max_wheat_corn: corn;
var 0..max_rice_soy: rice;
var 0..max_rice_soy: soybean;

var 0..(cost_wheat*max_wheat_corn + cost_corn*max_wheat_corn + cost_rice*max_rice_soy + cost_soy*max_rice_soy): total_cost;

% Constraints
constraint wheat + corn <= max_wheat_corn;
constraint rice + soybean <= max_rice_soy;

constraint wheat + rice >= min_wheat_rice;
constraint corn + soybean >= min_corn_soy;

constraint total_cost = cost_wheat*wheat + cost_corn*corn + cost_rice*rice + cost_soy*soybean;

% Objective
solve minimize total_cost;