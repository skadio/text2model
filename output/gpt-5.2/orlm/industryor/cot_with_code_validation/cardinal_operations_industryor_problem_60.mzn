% Parameters
int: N = 4;
set of int: DEV = 1..N;

array[DEV] of int: prep_cost = [1000, 920, 800, 700];
array[DEV] of int: unit_cost = [20, 24, 16, 28];
array[DEV] of int: cap = [900, 1000, 1200, 1600];

int: demand = 2000;

% Variables
array[DEV] of var 0..1: use;
array[DEV] of var 0..1600: x;

var 0..100000000: total_cost;

% Constraints
constraint forall(i in DEV) (
  x[i] <= cap[i] * use[i]
);

constraint sum(i in DEV)(x[i]) = demand;

constraint total_cost =
  sum(i in DEV)(prep_cost[i] * use[i] + unit_cost[i] * x[i]);

% Objective
solve minimize total_cost;