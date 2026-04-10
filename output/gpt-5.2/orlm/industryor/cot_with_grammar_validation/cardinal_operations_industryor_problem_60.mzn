% Parameters
int: nDevices = 4;
set of int: DEV = 1..nDevices;

array[DEV] of int: prepCost = [1000, 920, 800, 700];
array[DEV] of int: unitCost = [20, 24, 16, 28];
array[DEV] of int: capacity = [900, 1000, 1200, 1600];

int: demand = 2000;

% Variables
array[DEV] of var 0..1: use;
array[DEV] of var 0..2000: x;

% Constraints
constraint forall(d in DEV) (
  x[d] <= capacity[d] * use[d]
);

constraint sum(d in DEV)(x[d]) = demand;

% Objective
var int: totalCost = sum(d in DEV)(prepCost[d] * use[d] + unitCost[d] * x[d]);
solve minimize totalCost;