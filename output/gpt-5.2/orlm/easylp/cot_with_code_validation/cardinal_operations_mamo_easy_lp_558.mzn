% Parameters
int: total_budget = 500;

int: minX = 100;
int: minY = 50;
int: minZ = 20;

int: maxX = 300;
int: maxY = 200;
int: maxZ = 100;

int: costX = 40;
int: costY = 60;
int: costZ = 100;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;