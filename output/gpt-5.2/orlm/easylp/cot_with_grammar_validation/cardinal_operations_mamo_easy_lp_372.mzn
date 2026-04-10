% Parameters
int: max_hours = 24;
array[1..4] of int: cost = [3, 4, 5, 6];

% Variables
var 0..max_hours: X1;
var 0..max_hours: X2;
var 0..max_hours: X3;
var 0..max_hours: X4;

var 0..(max_hours * max(cost)): total_cost;

% Constraints
constraint X1 + X2 >= 10;
constraint X2 + X3 <= 20;
constraint X1 >= X4 + 5;
constraint X3 <= X4 + 10;

constraint total_cost = cost[1]*X1 + cost[2]*X2 + cost[3]*X3 + cost[4]*X4;

% Objective
solve minimize total_cost;