% Parameters
int: max_total = 50;
int: min_total = 30;

int: costX = 10;
int: costY = 20;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..(max_total * max(costX, costY)): total_cost;

% Constraints
constraint X + Y <= max_total;
constraint X + Y >= min_total;

constraint X >= 2 * Y;
constraint X - Y <= 10;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;