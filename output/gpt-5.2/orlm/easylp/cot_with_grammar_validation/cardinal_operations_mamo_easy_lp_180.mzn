% Parameters
int: total_limit = 1000;
int: min_balanced = 500;      % 2*X + Y >= 500
int: tech_limit = 600;        % X + 2*Z <= 600

int: costX = 6;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..total_limit: X;
var 0..total_limit: Y;
var 0..total_limit: Z;

var 0..(costX*total_limit + costY*total_limit + costZ*total_limit): total_cost;

% Constraints
constraint X + Y + Z <= total_limit;
constraint 2 * X + Y >= min_balanced;
constraint X + 2 * Z <= tech_limit;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;