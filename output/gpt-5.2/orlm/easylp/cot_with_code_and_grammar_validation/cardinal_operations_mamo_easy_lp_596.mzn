% Parameters
int: avail_x1 = 700;
int: avail_x2 = 500;
int: avail_x3 = 600;
int: avail_x4 = 800;

int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 70;
int: cost_x4 = 80;

int: op1_cap = 1000;   % x1 + x2 <= 1000
int: op2_cap = 1200;   % x3 + x4 <= 1200

int: min_heavy = 800;  % x1 + x3 >= 800
int: min_req  = 600;   % x2 + x4 >= 600

% Variables
var 0..avail_x1: x1;
var 0..avail_x2: x2;
var 0..avail_x3: x3;
var 0..avail_x4: x4;

var 0..(cost_x1*avail_x1 + cost_x2*avail_x2 + cost_x3*avail_x3 + cost_x4*avail_x4): total_cost;

% Constraints
constraint x1 + x2 <= op1_cap;
constraint x3 + x4 <= op2_cap;

constraint x1 + x3 >= min_heavy;
constraint x2 + x4 >= min_req;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;