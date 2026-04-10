% Parameters
int: cap_large = 25;
int: cap_tiny  = 6;

float: energy_large = 4.0;
float: energy_tiny  = 1.5;
float: energy_avail = 110.0;

int: min_tiny = 20;

% Variables
var 0..10000: n_large;
var min_tiny..10000: n_tiny;
var 0.0..1000000.0: total_weight;

% Constraints
constraint n_large = 2 * n_tiny;

constraint energy_large * int2float(n_large) + energy_tiny * int2float(n_tiny) <= energy_avail;

constraint total_weight = int2float(cap_large * n_large + cap_tiny * n_tiny);

% Objective
solve maximize total_weight;