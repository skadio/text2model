% Parameters (with values embedded)
int: cost_wheat = 10;
int: cost_corn = 20;
int: cost_soy = 30;

int: max_wheat_corn = 1000;
int: max_corn_soy = 1500;
int: min_wheat_soy = 500;
int: wheat_minus_corn_min = 200;

% Specific bounds on allocations (not provided explicitly in the description),
% so we model only non-negativity (whole acres) which is explicitly implied.
int: UB = 10000; % safe explicit upper bound for all acre variables

% Variables
var 0..UB: wheat;
var 0..UB: corn;
var 0..UB: soy;

var int: total_cost;

% Constraints
constraint wheat + corn <= max_wheat_corn;
constraint corn + soy <= max_corn_soy;
constraint wheat + soy >= min_wheat_soy;
constraint wheat - corn >= wheat_minus_corn_min;

constraint total_cost = cost_wheat * wheat + cost_corn * corn + cost_soy * soy;

% Objective
solve minimize total_cost;