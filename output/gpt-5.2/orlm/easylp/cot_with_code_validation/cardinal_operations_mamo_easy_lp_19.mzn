% Parameters
int: cost_X = 5;
int: cost_Y = 10;

int: a1_X = 2;
int: a1_Y = 3;
int: rhs1 = 100;

int: a2_X = 4;
int: a2_Y = 1;
int: rhs2 = 50;

% Variables
var 0..rhs2: x;
var 0..rhs2: y;
var 0..(cost_X*rhs2 + cost_Y*rhs2): total_cost;

% Constraints
constraint a1_X * x + a1_Y * y <= rhs1;
constraint a2_X * x + a2_Y * y >= rhs2;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;