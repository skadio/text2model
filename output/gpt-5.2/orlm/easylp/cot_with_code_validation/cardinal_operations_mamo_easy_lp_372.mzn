% Parameters
int: max_hours = 24;
array[1..4] of int: cost_per_hour = [3, 4, 5, 6];

% Variables
array[1..4] of var 0..max_hours: X; % X[1]=X1, X[2]=X2, X[3]=X3, X[4]=X4
var 0..(max_hours * sum(i in 1..4)(cost_per_hour[i])): total_cost;

% Constraints
constraint X[1] + X[2] >= 10;
constraint X[2] + X[3] <= 20;
constraint X[1] >= X[4] + 5;
constraint X[3] <= X[4] + 10;

% Objective
constraint total_cost = sum(i in 1..4)(cost_per_hour[i] * X[i]);
solve minimize total_cost;