% Parameters
int: cost_wheat = 10;
int: cost_corn = 20;
int: cost_soy = 30;

int: max_wheat_corn = 1000;
int: max_corn_soy = 1500;
int: min_wheat_soy = 500;
int: wheat_minus_corn_min = 200;

% Specific bounds (not provided explicitly; using nonnegative integers)
int: lb_wheat = 0;
int: lb_corn  = 0;
int: lb_soy   = 0;

int: ub_wheat = 2000;
int: ub_corn  = 2000;
int: ub_soy   = 2000;

% Variables
var lb_wheat..ub_wheat: wheat;
var lb_corn..ub_corn: corn;
var lb_soy..ub_soy: soy;

var 0..(cost_wheat*ub_wheat + cost_corn*ub_corn + cost_soy*ub_soy): total_cost;

% Constraints
constraint wheat + corn <= max_wheat_corn;
constraint corn + soy <= max_corn_soy;
constraint wheat + soy >= min_wheat_soy;
constraint wheat - corn >= wheat_minus_corn_min;

constraint total_cost = cost_wheat*wheat + cost_corn*corn + cost_soy*soy;

% Objective
solve minimize total_cost;