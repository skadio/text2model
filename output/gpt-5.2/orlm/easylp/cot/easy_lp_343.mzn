% Parameters (with values embedded)
int: n = 4;
set of int: R = 1..n;

array[R] of int: cost = [5, 4, 6, 7]; % costs for x1..x4

array[R] of int: lb = [0, 0, 0, 0];
array[R] of int: ub = [50, 40, 60, 70];

% Variables
array[R] of var int: x; % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4
var int: total_cost;

% Constraints
constraint forall(i in R) (lb[i] <= x[i] /\ x[i] <= ub[i]);

constraint x[1] + x[2] <= 20;
constraint x[3] + x[4] <= 30;
constraint x[1] + x[3] >= 15;
constraint x[2] + x[4] >= 10;

constraint total_cost = sum(i in R)(cost[i] * x[i]);

% Objective
solve minimize total_cost;