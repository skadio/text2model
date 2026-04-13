% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [500, 300, 700, 600];
array[P] of int: ub = [50, 60, 40, 30];

% Variables
array[P] of var 0..max(ub): x;

% Constraints
constraint forall(p in P) (x[p] <= ub[p]);

constraint x[1] + x[2] <= 100;
constraint 2 * x[3] + x[4] <= 120;
constraint x[1] + x[3] >= 60;
constraint x[2] + x[4] >= 80;

% Objective
solve minimize sum(p in P)(cost[p] * x[p]);