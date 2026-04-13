% Parameters
int: ca_A = 30;
int: mg_A = 50;
int: ca_B = 60;
int: mg_B = 10;

int: cost_A = 14;
int: cost_B = 25;

int: req_ca = 400;
int: req_mg = 50;

int: maxA = max(0, (req_ca div ca_A) + 10);
int: maxB = max(0, (req_ca div ca_B) + 10);

% Variables
var 0..maxA: xA; % servings of supplement A
var 0..maxB: xB; % servings of supplement B
var 0..(cost_A*maxA + cost_B*maxB): total_cost;

% Constraints
constraint ca_A * xA + ca_B * xB >= req_ca;
constraint mg_A * xA + mg_B * xB >= req_mg;

constraint total_cost = cost_A * xA + cost_B * xB;

% Objective
solve minimize total_cost;