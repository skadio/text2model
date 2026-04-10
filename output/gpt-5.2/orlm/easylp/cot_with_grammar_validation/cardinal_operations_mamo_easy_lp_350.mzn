% Parameters
int: n = 4;
set of int: DEPTS = 1..n;

array[DEPTS] of float: cost = [0.5, 0.2, 0.3, 0.4];

array[DEPTS] of int: ub = [100, 80, 60, 50];

% Variables
array[DEPTS] of var 0..100: x; % temporary common upper bound; tightened below
var float: total_cost;

% Constraints
constraint forall(i in DEPTS)(x[i] <= ub[i]);

constraint x[1] + x[2] <= 100;
constraint x[2] + x[3] >= 50;
constraint x[3] - x[4] <= 30;

constraint 10*x[1] + 15*x[2] - 5*x[3] - 20*x[4] >= 150;

constraint total_cost = sum(i in DEPTS)(cost[i] * int2float(x[i]));

% Objective
solve minimize total_cost;