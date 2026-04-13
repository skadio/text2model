% Parameters
int: max_total = 100;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

int: minX = 20;
int: minY = 30;
int: minZ = 10;

% Variables
var minX..max_total: X;
var minY..max_total: Y;
var minZ..max_total: Z;

var 0..(costX*max_total + costY*max_total + costZ*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

% Interpret "at least twice as much as that subtracted from the allocation for area Y"
% as: X >= 2*(Y - X)  (i.e., X is at least twice the shortfall from Y)
constraint X >= 2 * (Y - X);

% Similarly for Y and Z: Y >= 2*(Z - Y)
constraint Y >= 2 * (Z - Y);

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;