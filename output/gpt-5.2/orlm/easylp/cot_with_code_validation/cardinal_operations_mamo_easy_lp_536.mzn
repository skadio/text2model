% Parameters
int: cost_wheat = 10;
int: cost_corn = 20;
int: cost_soy = 30;

int: max_wheat_corn = 1000;
int: max_corn_soy = 1500;
int: min_wheat_soy = 500;
int: min_wheat_minus_corn = 200;

% Bounds (not specified numerically in the description; assume non-negative)
int: lb_wheat = 0;
int: lb_corn = 0;
int: lb_soy = 0;

int: ub_wheat = 2000;
int: ub_corn = 2000;
int: ub_soy = 2000;

% Variables
var lb_wheat..ub_wheat: wheat;
var lb_corn..ub_corn: corn;
var lb_soy..ub_soy: soy;

var int: total_cost;

% Constraints
constraint wheat + corn <= max_wheat_corn;
constraint corn + soy <= max_corn_soy;
constraint wheat + soy >= min_wheat_soy;
constraint wheat - corn >= min_wheat_minus_corn;

constraint total_cost = cost_wheat * wheat + cost_corn * corn + cost_soy * soy;

% Objective
solve minimize total_cost;