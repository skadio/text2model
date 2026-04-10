% Parameters
int: budget = 500;

int: minX = 100;
int: minY = 50;
int: minZ = 30;

int: maxX = 300;
int: maxY = 200;
int: maxZ = 150;

int: costX = 100;
int: costY = 200;
int: costZ = 150;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(budget * max(costX, max(costY, costZ))): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;