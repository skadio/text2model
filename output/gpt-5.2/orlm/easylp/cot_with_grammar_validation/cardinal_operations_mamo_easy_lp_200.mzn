% Parameters
int: budget = 10000;

int: minX = 200;
int: maxX = 5000;

int: minY = 100;
int: maxY = 4000;

int: minZ = 800;
int: maxZ = budget;

int: rhs2 = 3000;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y + Z <= budget;

% 0.07*X - 0.02*Y - 0.05*Z >= 0  (scaled by 100 to keep integers)
constraint 7*X - 2*Y - 5*Z >= 0;

% X - 2Y + Z >= 3000
constraint X - 2*Y + Z >= rhs2;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;