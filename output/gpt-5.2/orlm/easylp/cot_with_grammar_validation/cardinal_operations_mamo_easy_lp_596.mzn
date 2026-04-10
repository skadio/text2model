% Parameters
int: cap_x1 = 700;
int: cap_x2 = 500;
int: cap_x3 = 600;
int: cap_x4 = 800;

int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 70;
int: cost_x4 = 80;

int: op1_limit = 1000; % x1 + x2
int: op2_limit = 1200; % x3 + x4

int: min_heavy = 800;  % x1 or x3
int: min_req   = 600;  % x2 or x4

% Variables
var 0..cap_x1: x1;
var 0..cap_x2: x2;
var 0..cap_x3: x3;
var 0..cap_x4: x4;

var 0..(cost_x1*cap_x1 + cost_x2*cap_x2 + cost_x3*cap_x3 + cost_x4*cap_x4): total_cost;

% Constraints
constraint x1 + x2 <= op1_limit;
constraint x3 + x4 <= op2_limit;

constraint x1 + x3 >= min_heavy;
constraint x2 + x4 >= min_req;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;