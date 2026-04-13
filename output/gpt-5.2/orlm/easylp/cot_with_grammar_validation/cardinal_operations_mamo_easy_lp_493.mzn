% Parameters
int: max_vessels = 100;
int: min_capacity = 50;
int: max_diff = 20;

int: capX = 2;
int: capY = 3;

int: costX = 3;
int: costY = 2;

% Variables
var 0..max_vessels: X;
var 0..max_vessels: Y;
var 0..(costX*max_vessels + costY*max_vessels): total_cost;

% Constraints
constraint X + Y <= max_vessels;

constraint capX * X + capY * Y >= min_capacity;

constraint abs(X - Y) <= max_diff;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;