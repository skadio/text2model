% Parameters (with values embedded)
int: sleep_per_A = 3;
int: anti_per_A  = 5;
int: sleep_per_B = 6;
int: anti_per_B  = 1;

int: cost_A = 4;
int: cost_B = 5;

int: min_sleep = 40;
int: min_anti  = 50;

% Variables
var 0..1000: xA;  % number of pill A
var 0..1000: xB;  % number of pill B
var 0..100000: total_cost;

% Constraints
constraint sleep_per_A * xA + sleep_per_B * xB >= min_sleep;
constraint anti_per_A  * xA + anti_per_B  * xB >= min_anti;

constraint total_cost = cost_A * xA + cost_B * xB;

% Objective
solve minimize total_cost;