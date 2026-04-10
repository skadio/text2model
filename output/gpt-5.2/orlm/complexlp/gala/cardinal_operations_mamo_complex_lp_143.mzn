include "globals.mzn";

%------------------------------------------------------------
% Facility location / distribution planning (fixed + transport)
% Data embedded as given in the description.
%------------------------------------------------------------

int: m = 6;  % potential distribution centers
int: n = 8;  % retail stores

set of int: C = 1..m;
set of int: S = 1..n;

array[C] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[C,S] of int: shipCost =
 [| 2, 3, 3, 3, 5, 4, 3, 5
  | 2, 4, 2, 4, 5, 1, 4, 2
  | 5, 4, 1, 1, 3, 3, 2, 4
  | 4, 3, 4, 4, 1, 3, 5, 3
  | 5, 1, 2, 4, 1, 4, 2, 2
  | 1, 2, 5, 2, 4, 4, 4, 4 |];

array[S] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[C] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

% Decision variables
array[C] of var 0..1: open;                 % 1 if center c is opened
array[C,S] of var 0..max(demand): x;        % units shipped from center c to store s

% Constraints
constraint forall(s in S) (
  sum(c in C)(x[c,s]) = demand[s]
);

constraint forall(c in C) (
  sum(s in S)(x[c,s]) <= capacity[c] * open[c]
);

% Objective: opening + transportation
var int: totalOpenCost = sum(c in C)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in C, s in S)(shipCost[c,s] * x[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "OpenCost  = ", show(totalOpenCost), "\n",
  "ShipCost  = ", show(totalShipCost), "\n",
  "Open      = ", show(open), "\n",
  "Shipments x[c,s] (rows=centers, cols=stores):\n",
  concat([ concat([ show(x[c,s]) ++ if s < n then "\t" else "\n" endif | s in S ]) | c in C ])
];