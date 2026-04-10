% Parameters
% Devices indexed as: 1=A, 2=B, 3=C, 4=D
set of int: DEV = 1..4;

% Demand to be produced (units)
int: demand = 2000;

% Fixed (preparation completion) cost if device is enabled (Yuan)
array[DEV] of int: prep_cost = [1000, 920, 800, 700];

% Unit production cost on each device (Yuan/unit)
array[DEV] of int: unit_cost = [20, 24, 16, 28];

% Maximum processing capacity of each device (units)
array[DEV] of int: capacity = [900, 1000, 1200, 1600];


% Variables
% x[d] = units produced on device d
array[DEV] of var 0..demand: x;

% y[d] = 1 if device d is enabled (and fixed cost is paid), else 0
array[DEV] of var 0..1: y;


% Constraints
% Demand satisfaction: produce exactly the required demand
constraint sum(d in DEV)(x[d]) = demand;

% Activation/capacity linking: cannot produce unless enabled, and capped by capacity
constraint forall(d in DEV) (
  x[d] <= capacity[d] * y[d]
);

% Capacity bounds (redundant given linking, kept for clarity)
constraint forall(d in DEV) (
  x[d] <= capacity[d]
);


% Objective
% Minimize fixed enabling costs + variable production costs
solve minimize
  sum(d in DEV)(prep_cost[d] * y[d] + unit_cost[d] * x[d]);