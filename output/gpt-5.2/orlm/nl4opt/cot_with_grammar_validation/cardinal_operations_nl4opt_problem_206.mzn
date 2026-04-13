% Parameters
int: ca_A = 30;
int: mg_A = 50;
int: cost_A = 14;

int: ca_B = 60;
int: mg_B = 10;
int: cost_B = 25;

int: ca_req = 400;
int: mg_req = 50;

% Variables
var 0..1000: xA; % servings of supplement A
var 0..1000: xB; % servings of supplement B
var 0..1000000: total_cost;

% Constraints
constraint ca_A * xA + ca_B * xB >= ca_req;
constraint mg_A * xA + mg_B * xB >= mg_req;

constraint total_cost = cost_A * xA + cost_B * xB;

% Objective
solve minimize total_cost;