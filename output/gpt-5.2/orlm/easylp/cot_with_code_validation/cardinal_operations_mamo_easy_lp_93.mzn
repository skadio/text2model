% Parameters
int: capacity = 1000;
int: demand = 800;
int: balance = 200;
int: costX = 2;
int: costY = 3;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..(costX*capacity + costY*capacity): total_cost;

% Constraints
constraint X + Y <= capacity;
constraint 2*X + Y >= demand;
constraint abs(X - 2*Y) <= balance;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;