include "globals.mzn";

%-----------------------
% Data (embedded)
%-----------------------
int: nCenters = 5;
int: nStores  = 6;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[Centers, Stores] of int: shipCost =
 [| 5, 2, 3, 3, 3, 5
  | 4, 3, 5, 2, 4, 2
  | 4, 5, 1, 4, 2, 5
  | 4, 1, 1, 3, 3, 2
  | 4, 4, 3, 4, 4, 1 |];

array[Stores] of int: demand = [530, 884, 420, 566, 673, 787];

array[Centers] of int: capacity = [1400, 1115, 813, 1041, 1576];

% Upper bound for shipped units on any lane
int: maxDemand = max(demand);

%-----------------------
% Decision variables
%-----------------------
array[Centers] of var 0..1: open;                    % 1 if center opened
array[Centers, Stores] of var 0..maxDemand: x;       % units shipped center->store

%-----------------------
% Constraints
%-----------------------

% Meet each store's demand exactly
constraint forall(s in Stores)(
  sum(c in Centers)(x[c,s]) = demand[s]
);

% Do not exceed each center's capacity (only if opened)
constraint forall(c in Centers)(
  sum(s in Stores)(x[c,s]) <= capacity[c] * open[c]
);

%-----------------------
% Objective
%-----------------------
var int: totalOpenCost = sum(c in Centers)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in Centers, s in Stores)(shipCost[c,s] * x[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%-----------------------
% Output
%-----------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "  Open cost = ", show(totalOpenCost), "\n",
  "  Ship cost = ", show(totalShipCost), "\n\n",
  "Open centers (1=open): ", show(open), "\n\n",
  "Shipments x[center,store]:\n",
  concat([ "Center " ++ show(c) ++ ": " ++ show([x[c,s] | s in Stores]) ++ "\n" | c in Centers ])
];