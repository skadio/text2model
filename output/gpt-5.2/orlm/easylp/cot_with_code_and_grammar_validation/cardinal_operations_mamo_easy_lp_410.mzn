% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [5, 7, 3, 4];

int: budget_max = 100;

array[P] of int: max_invest = [40, 50, 30, 20];

array[P] of int: div_w = [1, 4, 1, 2];
int: div_min = 50;

array[P] of int: eq_w = [3, 1, 2, 1];
int: eq_rhs = 75;

% Variables
array[P] of var 0..100: x;
var int: total_cost;

% Constraints
constraint forall(i in P) (x[i] <= max_invest[i]);

constraint sum(i in P)(x[i]) <= budget_max;

constraint sum(i in P)(div_w[i] * x[i]) >= div_min;

constraint sum(i in P)(eq_w[i] * x[i]) = eq_rhs;

constraint total_cost = sum(i in P)(cost[i] * x[i]);

% Objective
solve minimize total_cost;