% Parameters
int: MAX_EMP = 100;
int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Variables
var 0..MAX_EMP: x;
var 0..MAX_EMP: y;
var 0..MAX_EMP: z;
var 0..(MAX_EMP * max([costX, costY, costZ])): total_cost;

% Constraints
constraint x + y + z <= MAX_EMP;

% x >= 2 * (y/2)  <=> x >= y
constraint x >= y;

% z <= (3/4)x + 10  <=> 4z <= 3x + 40
constraint 4 * z <= 3 * x + 40;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;