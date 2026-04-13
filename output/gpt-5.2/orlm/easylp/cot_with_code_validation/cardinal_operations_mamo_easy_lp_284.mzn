% Parameters
int: total_limit = 100;
int: costX = 500;
int: costY = 300;
int: costZ = 700;

int: minX = 20;
int: minY = 30;
int: minZ = 10;

% Variables
var minX..total_limit: X;
var minY..total_limit: Y;
var minZ..total_limit: Z;

var 0..(costX*total_limit + costY*total_limit + costZ*total_limit): total_cost;

% Constraints
constraint X + Y + Z <= total_limit;

% Interpret "X should be at least twice as much as that subtracted from Y" as X >= 2*(Y - X)
% which simplifies to 3*X >= 2*Y
constraint 3 * X >= 2 * Y;

% Interpret "Y should be at least twice as much as that subtracted from Z" as Y >= 2*(Z - Y)
% which simplifies to 3*Y >= 2*Z
constraint 3 * Y >= 2 * Z;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;