% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [10, 12, 20, 15];

array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [600, 500, 400, 300];

% Variables
array[P] of var int: x;
var int: total_cost;

% Constraints
constraint forall(i in P) (x[i] >= lb[i]);
constraint forall(i in P) (x[i] <= ub[i]);

constraint x[1] + x[2] <= 1000;
constraint 2 * x[1] + x[3] <= 1500;
constraint 3 * x[2] + 2 * x[4] >= 1200;

constraint x[3] - x[4] <= 500;
constraint x[4] - x[3] <= 500;

constraint total_cost = sum(i in P)(cost[i] * x[i]);

% Objective
solve minimize total_cost;