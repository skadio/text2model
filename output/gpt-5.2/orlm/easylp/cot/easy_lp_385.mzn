% Parameters (with values embedded)
int: n = 4;
set of int: SITES = 1..n;

array[SITES] of int: cost = [100, 200, 300, 400];
array[SITES] of int: ub   = [20, 15, 25, 30];

% Variables
array[SITES] of var int: x; % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4
var int: total_cost;

% Constraints
constraint forall(i in SITES) (0 <= x[i] /\ x[i] <= ub[i]);

constraint x[1] + x[2] <= 30;
constraint 2*x[3] + x[4] <= 40;
constraint x[1] + x[2] + x[3] >= 20;

% x3 - 0.5*x4 <= 10  <=>  2*x3 - x4 <= 20 (integer-safe)
constraint 2*x[3] - x[4] <= 20;

constraint total_cost = sum(i in SITES)(cost[i] * x[i]);

% Objective
solve minimize total_cost;