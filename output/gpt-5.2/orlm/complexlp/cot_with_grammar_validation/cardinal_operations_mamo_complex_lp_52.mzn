% Parameters
int: N = 5;
set of int: R = 1..N;

array[R] of int: stock = [410, 266, 132, 6, 485];
array[R] of int: need  = [274, 331, 232, 359, 74];

array[R, R] of int: cost =
[|  0, 24,  3, 27, 31
 | 24,  0, 11,  7, 37
 | 30,  1,  0, 38, 22
 | 36, 18, 17,  0, 35
 | 41, 35, 33, 33,  0 |];

array[R] of int: surplus = [max(0, stock[i] - need[i]) | i in R];
array[R] of int: deficit = [max(0, need[i] - stock[i]) | i in R];

int: total_surplus = sum(i in R)(surplus[i]);
int: total_deficit = sum(i in R)(deficit[i]);

% Variables
array[R, R] of var 0..total_surplus: x;  % shipped from i to j

var 0..(total_surplus * max(i,j in R)(cost[i,j])): total_cost;

% Constraints
constraint forall(i in R)(x[i,i] = 0);

% Ship out of i cannot exceed surplus at i
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= surplus[i]
);

% Ship into j must meet deficit at j
constraint forall(j in R)(
  sum(i in R)(x[i,j]) >= deficit[j]
);

% Feasibility (should hold for given data)
constraint total_surplus >= total_deficit;

% Cost definition
constraint total_cost =
  sum(i in R, j in R)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;