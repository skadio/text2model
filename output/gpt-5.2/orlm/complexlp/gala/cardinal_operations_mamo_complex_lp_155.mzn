include "globals.mzn";

% Facility location / capacitated distribution with fixed opening costs
int: nCenters = 9;
int: nStores  = 5;

set of int: C = 1..nCenters;
set of int: S = 1..nStores;

array[C] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[C,S] of int: shipCost = array2d(C, S,
[
  3,5,4,3,5,
  2,4,2,4,5,
  1,4,2,5,4,
  1,1,3,3,2,
  4,4,3,4,4,
  1,3,5,3,5,
  1,2,4,1,4,
  2,2,1,2,5,
  2,4,4,4,4
]);

array[S] of int: demand = [908, 434, 605, 480, 961];
array[C] of int: capacity = [1825, 1821, 1365, 1929, 1502, 1201, 1529, 961, 1001];

% Decision variables
array[C] of var 0..1: open;                 % 1 if distribution center is opened
array[C,S] of var 0..max(demand): flow;     % units shipped from center c to store s

% Demand satisfaction
constraint forall(s in S)(
  sum(c in C)(flow[c,s]) = demand[s]
);

% Capacity and linking to opening decision
constraint forall(c in C)(
  sum(s in S)(flow[c,s]) <= capacity[c] * open[c]
);

% Objective: opening costs + transportation costs
var int: totalOpenCost = sum(c in C)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in C, s in S)(shipCost[c,s] * flow[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "OpenCost  = ", show(totalOpenCost), "\n",
  "ShipCost  = ", show(totalShipCost), "\n",
  "Open = ", show(open), "\n",
  "Flow (rows=centers, cols=stores) =\n",
  concat([ concat([ show(flow[c,s]) ++ if s==nStores then "\n" else "\t" endif
                   | s in S ])
          | c in C ])
];