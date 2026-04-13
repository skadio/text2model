% Parameters
int: MAX_HOURS = 24;
array[1..4] of int: cost = [3, 4, 5, 6];

% Variables
array[1..4] of var 0..MAX_HOURS: x; % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4
var int: total_cost;

% Constraints
constraint x[1] + x[2] >= 10;
constraint x[2] + x[3] <= 20;
constraint x[1] >= x[4] + 5;
constraint x[3] <= x[4] + 10;

constraint total_cost = sum(i in 1..4)(cost[i] * x[i]);

% Objective
solve minimize total_cost;