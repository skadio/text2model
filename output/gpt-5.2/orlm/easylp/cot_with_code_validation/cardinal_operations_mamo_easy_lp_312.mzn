% Parameters
int: total_cap = 1000;
int: yz_cap = 800;

int: costX = 500;
int: costY = 700;
int: costZ = 300;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;
constraint X >= 2*Y + 200;
constraint Y + Z <= yz_cap;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;