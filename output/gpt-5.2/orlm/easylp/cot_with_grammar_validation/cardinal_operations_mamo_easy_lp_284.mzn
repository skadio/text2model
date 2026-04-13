% Parameters
int: total_cap = 100;
int: costX = 500;
int: costY = 300;
int: costZ = 700;

int: minX = 20;
int: minY = 30;
int: minZ = 10;

% Variables
var minX..total_cap: X;
var minY..total_cap: Y;
var minZ..total_cap: Z;

var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;

% Interpret "at least twice as much as that subtracted from the allocation for area Y"
% as: X >= 2*(Y - X)  => 3*X >= 2*Y
constraint 3 * X >= 2 * Y;

% Interpret "at least twice as much as that subtracted from the allocation for area Z"
% as: Y >= 2*(Z - Y)  => 3*Y >= 2*Z
constraint 3 * Y >= 2 * Z;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;