% Parameters
int: sleep_A = 3;
int: anti_A  = 5;
int: cost_A  = 4;

int: sleep_B = 6;
int: anti_B  = 1;
int: cost_B  = 5;

int: req_sleep = 40;
int: req_anti  = 50;

% Variables
var 0..req_sleep: xA; % number of pill A
var 0..req_sleep: xB; % number of pill B

% Constraints
constraint sleep_A * xA + sleep_B * xB >= req_sleep;
constraint anti_A  * xA + anti_B  * xB >= req_anti;

% Objective
solve minimize cost_A * xA + cost_B * xB;