% Parameters
int: BUDGET = 1000;
int: C1 = 200;
int: C2 = 300;
int: C3 = 50;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint 5 * X - 2 * Y >= C1;

constraint Z - Y <= C2;

constraint X >= Z + C3;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;