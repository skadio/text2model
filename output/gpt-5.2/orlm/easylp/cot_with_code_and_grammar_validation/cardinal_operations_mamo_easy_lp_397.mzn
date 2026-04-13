% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [5, 7, 3, 4];

% Maximum allocations (must be provided in the description but not numerically specified);
% Use large safe upper bounds if not explicitly given.
array[P] of int: ub = [1000000, 1000000, 1000000, 1000000];

% Variables
array[P] of var 0..1000000: x;

% Constraints
constraint forall(i in P)(x[i] <= ub[i]);

% 2*x1 + x2 - 0.5*x3 <= 50  ->  4*x1 + 2*x2 - x3 <= 100
constraint 4*x[1] + 2*x[2] - x[3] <= 100;

% x1 + 2.5*x2 - x4 >= 30  ->  2*x1 + 5*x2 - 2*x4 >= 60
constraint 2*x[1] + 5*x[2] - 2*x[4] >= 60;

% -0.75*x1 + x3 + x4 <= 20  ->  -3*x1 + 4*x3 + 4*x4 <= 80
constraint -3*x[1] + 4*x[3] + 4*x[4] <= 80;

% -x1 - x2 + 0.6*x4 >= 10  ->  -5*x1 - 5*x2 + 3*x4 >= 50
constraint -5*x[1] - 5*x[2] + 3*x[4] >= 50;

% Objective
var int: total_cost = sum(i in P)(cost[i] * x[i]);
solve minimize total_cost;