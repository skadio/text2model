% Parameters
int: sleep_A = 3;
int: anti_A  = 5;
int: cost_A  = 4;

int: sleep_B = 6;
int: anti_B  = 1;
int: cost_B  = 5;

int: min_sleep = 40;
int: min_anti  = 50;

% Variables
var 0..ceil(int2float(min_sleep) / int2float(sleep_A)): xA; % number of pill A
var 0..ceil(int2float(min_sleep) / int2float(sleep_B)): xB; % number of pill B

% Constraints
constraint sleep_A * xA + sleep_B * xB >= min_sleep;
constraint anti_A  * xA + anti_B  * xB >= min_anti;

% Objective
var int: total_cost = cost_A * xA + cost_B * xB;
solve minimize total_cost;