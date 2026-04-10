% Parameters
int: total_budget = 50000;
int: diff_XY = 10000;
int: diff_YZ = 5000;

int: costX = 1000;
int: costY = 800;
int: costZ = 600;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(costX*total_budget + costY*total_budget + costZ*total_budget): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;

constraint X >= Y + diff_XY;
constraint Y >= Z + diff_YZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;