% Parameters
int: total_cap = 1000;
int: min_strength = 400;
int: yz_cap = 600;

int: costX = 4;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;
constraint 2*X + Y >= min_strength;
constraint Y + Z <= yz_cap;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;