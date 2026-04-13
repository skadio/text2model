% Parameters
int: cost_x = 5;
int: cost_y = 10;

int: a1_x = 2;
int: a1_y = 3;
int: b1 = 100;

int: a2_x = 4;
int: a2_y = 1;
int: b2 = 50;

% Variables
var 0..b1: x;
var 0..b1: y;
var 0..(cost_x*b1 + cost_y*b1): total_cost;

% Constraints
constraint a1_x * x + a1_y * y <= b1;
constraint a2_x * x + a2_y * y >= b2;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;