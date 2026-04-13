% Parameters
int: budget = 500;

int: minX = 100;
int: minY = 50;
int: minZ = 30;

int: maxX = 300;
int: maxY = 200;
int: maxZ = 150;

int: retX = 100;
int: retY = 200;
int: retZ = 150;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(maxX*retX + maxY*retY + maxZ*retZ): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint total_cost = retX*X + retY*Y + retZ*Z;

% Objective
solve minimize total_cost;