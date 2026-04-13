% Facility location / capacitated transportation (fixed-charge + variable costs)
% Data embedded as requested.

include "globals.mzn";

int: nDC = 6;
int: nS  = 9;

set of int: DC = 1..nDC;
set of int: S  = 1..nS;

% Opening costs ($)
array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

% Transportation cost per unit ($/unit), DC x Store
array[DC, S] of int: shipCost =
[
  % DC1 -> stores 1..9
  2, 3, 1, 4, 2, 3, 2, 1, 2,
  % DC2
  4, 2, 3, 1, 4, 2, 3, 2, 4,
  % DC3
  1, 1, 2, 3, 2, 4, 3, 2, 4,
  % DC4
  4, 1, 3, 2, 2, 3, 1, 2, 4,
  % DC5
  1, 4, 2, 2, 3, 1, 2, 3, 4,
  % DC6
  4, 4, 3, 2, 1, 2, 3, 4, 4
];

% Store demands (units) (Store 1 is 401, Store 7 is 955; others in-between)
array[S] of int: demand = [401, 512, 623, 734, 845, 906, 955, 678, 589];

% DC supply capacities (units) (DC1 is 1795, DC6 is 1095; others vary)
array[DC] of int: capacity = [1795, 1500, 1300, 1600, 1400, 1095];

% Decision variables
array[DC] of var 0..1: open;
array[DC, S] of var 0..max(demand): x; % shipped units from DC to Store

% Demand satisfaction
constraint forall(s in S)(
  sum(d in DC)(x[d,s]) = demand[s]
);

% Capacity and linking to opening decision
constraint forall(d in DC)(
  sum(s in S)(x[d,s]) <= capacity[d] * open[d]
);

% Objective: opening + transportation
var int: totalCost =
  sum(d in DC)(openCost[d] * open[d]) +
  sum(d in DC, s in S)(shipCost[d,s] * x[d,s]);

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "Open = ", show(open), "\n",
  "Shipments x[d,s] (rows=DC 1..6, cols=Store 1..9):\n",
  concat([ concat([ show(x[d,s]) ++ if s<nS then "\t" else "\n" endif
                    | s in S ])
           | d in DC ])
];