% Parameters
int: cost_x = 5;
int: cost_y = 3;

int: a1_x = 2;
int: a1_y = 4;
int: rhs1 = 50;

int: a2_x = 3;
int: a2_y = 1;
int: rhs2 = 30;

% Variables
var 0..1000: x;
var 0..1000: y;

% Constraints
constraint a1_x * x + a1_y * y >= rhs1;
constraint a2_x * x + a2_y * y <= rhs2;

% Objective
var 0..100000: total_cost;
constraint total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;