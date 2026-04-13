% Parameters (with values embedded)
int: budget = 1000;
int: rhs1 = 10;          % 3X + 2Y - Z >= 10
int: diffZY = 30;        % Z - Y >= 30

int: costX = 5;
int: costY = 6;
int: costZ = 7;

int: maxX = 500;
int: maxY = 400;
int: minZ = 50;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var minZ..budget: Z;

% Constraints
constraint X + Y + Z <= budget;
constraint 3*X + 2*Y - Z >= rhs1;
constraint Z - Y >= diffZY;

% Objective
var int: total_cost = costX*X + costY*Y + costZ*Z;
solve minimize total_cost;