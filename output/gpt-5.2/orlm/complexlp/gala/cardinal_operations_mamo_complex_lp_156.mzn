include "globals.mzn";

%-----------------------------
% Data (embedded as requested)
%-----------------------------
int: nCenters = 7;
int: nStores  = 6;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[Centers, Stores] of int: shipCost =
  [| 3, 3, 5, 4, 3, 5
   | 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4, 3
   | 4, 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1, 4
   | 2, 2, 1, 2, 5, 2 |];

array[Stores] of int: demand = [739, 491, 766, 854, 827, 908];
array[Centers] of int: capacity = [1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in Stores)(demand[s]);

%-----------------------------
% Decision variables
%-----------------------------
array[Centers] of var 0..1: open;  % 1 if center is opened

% flow[c,s] = units shipped from center c to store s
array[Centers, Stores] of var 0..totalDemand: flow;

%-----------------------------
% Constraints
%-----------------------------
% Meet each store's demand exactly
constraint forall(s in Stores)(
  sum(c in Centers)(flow[c,s]) = demand[s]
);

% Do not exceed each center's capacity; if closed then ship nothing
constraint forall(c in Centers)(
  sum(s in Stores)(flow[c,s]) <= capacity[c] * open[c]
);

%-----------------------------
% Objective: minimize total cost
%-----------------------------
var int: totalOpenCost = sum(c in Centers)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in Centers, s in Stores)(shipCost[c,s] * flow[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "Open centers = ", show([ c | c in Centers where fix(open[c]) = 1 ]), "\n",
  "Open vector = ", show(open), "\n",
  "Total open cost = ", show(totalOpenCost), "\n",
  "Total ship cost = ", show(totalShipCost), "\n",
  "Flows (center x store) =\n", show2d(flow), "\n"
];