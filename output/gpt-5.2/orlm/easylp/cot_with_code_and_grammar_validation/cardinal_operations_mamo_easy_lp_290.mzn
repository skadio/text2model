% Parameters
int: min_total_resources = 50;
int: rhs1 = 30;   % 4*X - Y <= 30
int: rhs2 = 10;   % Z - 2*Y >= 10

int: costX = 5;
int: costY = 3;
int: costZ = 2;

% Variables
var 0..100000: X;
var 0..100000: Y;
var 0..100000: Z;

var 0..1000000: total_cost;

% Constraints
constraint X + Y + Z >= min_total_resources;

constraint 4*X - Y <= rhs1;

constraint Z - 2*Y >= rhs2;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;