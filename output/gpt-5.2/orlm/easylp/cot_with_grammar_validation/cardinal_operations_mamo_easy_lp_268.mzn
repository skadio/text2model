% Parameters
int: max_total = 100;
int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;
var 0..(max_total * max([costX, costY, costZ])): total_cost;

% Constraints
constraint x + y + z <= max_total;

% "x should be at least twice the half of y"  => x >= y
constraint x >= y;

% "z should not exceed by more than 10 the three-fourths of x"
% z <= (3/4)*x + 10  <=>  4*z <= 3*x + 40
constraint 4 * z <= 3 * x + 40;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;