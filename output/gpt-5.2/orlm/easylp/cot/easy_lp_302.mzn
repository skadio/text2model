% Parameters (with values embedded)
int: BUDGET = 1000;
int: RHS1 = 200;
int: RHS2 = 500;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X - 2*Y + Z >= RHS1;
constraint 2*X + Y - Z <= RHS2;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;