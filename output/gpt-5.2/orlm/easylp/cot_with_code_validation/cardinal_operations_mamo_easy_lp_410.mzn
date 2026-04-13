% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [5, 7, 3, 4];
array[P] of int: ub   = [40, 50, 30, 20];

int: total_cap = 100;

array[P] of int: a1 = [1, 4, 1, 2];
int: rhs1 = 50;

array[P] of int: a2 = [3, 1, 2, 1];
int: rhs2 = 75;

% Variables
array[P] of var 0..100: x;
var 0..10000: total_cost;

% Constraints
constraint forall(i in P)(x[i] <= ub[i]);

constraint sum(i in P)(x[i]) <= total_cap;

constraint sum(i in P)(a1[i] * x[i]) >= rhs1;

constraint sum(i in P)(a2[i] * x[i]) = rhs2;

constraint total_cost = sum(i in P)(cost[i] * x[i]);

% Objective
solve minimize total_cost;