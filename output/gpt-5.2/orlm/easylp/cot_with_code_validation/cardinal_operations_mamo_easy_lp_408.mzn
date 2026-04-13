% Parameters
int: n = 4;
set of int: C = 1..n;

array[C] of int: cost = [100, 200, 150, 250];

array[C] of int: lb = [0, 0, 0, 0];
array[C] of int: ub = [5000, 5000, 6000, 6000];

int: max12 = 5000;
int: max34 = 6000;
int: min13 = 3000;
int: min24 = 4000;

% Variables
array[C] of var int: x;
var int: total_cost;

% Constraints
constraint forall(i in C) (lb[i] <= x[i] /\ x[i] <= ub[i]);

constraint x[1] + x[2] <= max12;
constraint x[3] + x[4] <= max34;
constraint x[1] + x[3] >= min13;
constraint x[2] + x[4] >= min24;

constraint total_cost = sum(i in C)(cost[i] * x[i]);

% Objective
solve minimize total_cost;