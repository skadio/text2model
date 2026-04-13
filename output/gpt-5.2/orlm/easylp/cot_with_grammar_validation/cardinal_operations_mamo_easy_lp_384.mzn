% Parameters
int: n = 4;
set of int: A = 1..n;

array[A] of int: cost = [20, 30, 50, 60];

array[A] of int: lb = [0, 0, 0, 0];
array[A] of int: ub = [15, 12, 10, 8];

% Variables
array[A] of var int: x;
var int: total_cost;

% Constraints
constraint forall(i in A) (lb[i] <= x[i] /\ x[i] <= ub[i]);

% x1 + x2 >= 5
constraint x[1] + x[2] >= 5;

% |x3 - x4| <= 10
constraint abs(x[3] - x[4]) <= 10;

% 2*x1 + 3*x2 - x4 >= 8
constraint 2*x[1] + 3*x[2] - x[4] >= 8;

% |x1 - x3| <= 6
constraint abs(x[1] - x[3]) <= 6;

constraint total_cost = sum(i in A)(cost[i] * x[i]);

% Objective
solve minimize total_cost;