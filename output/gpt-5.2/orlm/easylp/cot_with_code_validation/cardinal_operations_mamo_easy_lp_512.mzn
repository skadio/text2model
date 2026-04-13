% Parameters
int: CAP = 1000;
int: DEMAND = 300;
int: LIMIT = 600;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..CAP: X;
var 0..CAP: Y;
var 0..CAP: Z;

var 0..(costX*CAP + costY*CAP + costZ*CAP): total_cost;

% Constraints
constraint X + Y + Z <= CAP;
constraint 2*X + Y >= DEMAND;
constraint X + 3*Z <= LIMIT;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;