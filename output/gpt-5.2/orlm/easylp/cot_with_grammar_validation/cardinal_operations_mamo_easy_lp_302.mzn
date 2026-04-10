% Parameters
int: BUDGET = 1000;
int: C1_RHS = 200;
int: C2_RHS = 500;

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

constraint X - 2*Y + Z >= C1_RHS;

constraint 2*X + Y - Z <= C2_RHS;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;