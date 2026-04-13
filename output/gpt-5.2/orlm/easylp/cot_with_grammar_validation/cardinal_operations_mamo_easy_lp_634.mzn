% Parameters
int: n = 4;
set of int: DEST = 1..n;

array[DEST] of int: cost = [200, 150, 100, 50];

int: max12 = 300;
int: max34 = 200;
int: min13 = 150;
int: min24 = 150;

% Variables
array[DEST] of var 0..300: x;

var 0..(max12*max(cost[1],cost[2]) + max34*max(cost[3],cost[4])): total_cost;

% Constraints
constraint x[1] + x[2] <= max12;
constraint x[3] + x[4] <= max34;

constraint x[1] + x[3] >= min13;
constraint x[2] + x[4] >= min24;

constraint total_cost = sum(i in DEST)(cost[i] * x[i]);

% Objective
solve minimize total_cost;