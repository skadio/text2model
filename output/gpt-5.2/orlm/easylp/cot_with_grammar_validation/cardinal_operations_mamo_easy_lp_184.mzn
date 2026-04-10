% Parameters
int: CAP = 1000;
int: DEMAND = 600;
int: DIFF_MAX = 200;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..CAP: X;
var 0..CAP: Y;
var 0..CAP: Z;
var 0..(CAP * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= CAP;
constraint 3 * X + 4 * Y >= DEMAND;
constraint 5 * Z - Y <= DIFF_MAX;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;