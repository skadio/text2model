% Parameters
set of int: DEV = 1..4;
array[DEV] of string: dev_name = ["A","B","C","D"];

array[DEV] of int: prep_cost = [1000, 920, 800, 700];          % Yuan (fixed if enabled)
array[DEV] of int: unit_cost = [20, 24, 16, 28];               % Yuan per unit
array[DEV] of int: capacity  = [900, 1000, 1200, 1600];        % units

int: demand = 2000;

int: max_total_cost = sum(d in DEV)(prep_cost[d] + unit_cost[d] * capacity[d]);

% Variables
array[DEV] of var 0..1: use;
array[DEV] of var 0..max(capacity): x;
var 0..max_total_cost: total_cost;

% Constraints
constraint forall(d in DEV) (
  x[d] <= capacity[d]
);

constraint forall(d in DEV) (
  x[d] <= capacity[d] * use[d]
);

constraint sum(d in DEV)(x[d]) = demand;

constraint total_cost =
  sum(d in DEV)(prep_cost[d] * use[d] + unit_cost[d] * x[d]);

% Objective
solve minimize total_cost;