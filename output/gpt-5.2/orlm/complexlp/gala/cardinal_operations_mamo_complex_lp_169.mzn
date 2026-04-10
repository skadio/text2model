include "globals.mzn";

% Capacitated facility location / distribution center opening with shipment quantities

int: m = 6; % distribution centers
int: n = 8; % retail stores

set of int: DC = 1..m;
set of int: S  = 1..n;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[S] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];

array[DC] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

% Transportation cost per unit from each DC to each store (6x8)
array[DC, S] of int: shipCost =
[
 % S1 S2 S3 S4 S5 S6 S7 S8
   2, 3, 1, 4, 3, 2, 4, 5,   % DC1
   2, 4, 2, 5, 2, 3, 4, 2,   % DC2
   5, 4, 3, 2, 1, 2, 3, 4,   % DC3
   4, 3, 2, 1, 2, 4, 5, 3,   % DC4
   5, 1, 2, 3, 4, 5, 1, 2,   % DC5
   1, 2, 3, 4, 5, 1, 2, 4    % DC6
];

% Decision variables
array[DC] of var 0..1: open;
array[DC, S] of var 0..max(demand): x; % units shipped from DC d to store s

% Demand satisfaction (all demand must be met)
constraint forall(s in S) (
  sum(d in DC)(x[d,s]) = demand[s]
);

% Capacity constraints and linking to opening decisions
constraint forall(d in DC) (
  sum(s in S)(x[d,s]) <= capacity[d] * open[d]
);

% Objective: opening cost + transportation cost
var int: totalCost =
  sum(d in DC)(openCost[d] * open[d]) +
  sum(d in DC, s in S)(shipCost[d,s] * x[d,s]);

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "Open = ", show(open), "\n",
  "Shipments x[d,s] (rows=DC1..DC6, cols=Store1..Store8):\n",
  concat([ concat([ show(x[d,s]) ++ if s==n then "\n" else "\t" endif | s in S ]) | d in DC ])
];