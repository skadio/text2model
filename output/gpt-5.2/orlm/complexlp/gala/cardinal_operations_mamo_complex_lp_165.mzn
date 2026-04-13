include "globals.mzn";

%---------- Data (embedded) ----------
int: nCenters = 6;
int: nStores  = 4;

array[1..nCenters] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[1..nCenters, 1..nStores] of int: shipCost =
 [| 2, 3, 3, 3
  | 5, 4, 3, 5
  | 2, 4, 2, 4
  | 5, 1, 4, 2
  | 5, 4, 1, 1
  | 3, 3, 2, 4 |];

array[1..nStores] of int: demand = [589, 962, 966, 643];

array[1..nCenters] of int: capacity = [1631, 1954, 1446, 820, 1640, 966];

% A safe upper bound on any single flow is total demand.
int: totalDemand = sum(s in 1..nStores)(demand[s]);

%---------- Decision variables ----------
array[1..nCenters] of var 0..1: open; % 1 if center is opened
array[1..nCenters, 1..nStores] of var 0..totalDemand: x; % shipped units

%---------- Constraints ----------
% Meet each store's demand exactly
constraint forall(s in 1..nStores)(
  sum(c in 1..nCenters)(x[c,s]) = demand[s]
);

% Do not exceed each center's capacity, and ship nothing if not opened
constraint forall(c in 1..nCenters)(
  sum(s in 1..nStores)(x[c,s]) <= capacity[c] * open[c]
);

%---------- Objective ----------
var int: totalCost =
  sum(c in 1..nCenters)(openCost[c] * open[c]) +
  sum(c in 1..nCenters, s in 1..nStores)(shipCost[c,s] * x[c,s]);

solve minimize totalCost;

output [ show(totalCost) ];