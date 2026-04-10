% Parameters
int: max_total = 1000;
int: demand_min = 600;
int: balance_max = 200;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(max_total * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint 3 * X + 4 * Y >= demand_min;

constraint 5 * Z - Y <= balance_max;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;