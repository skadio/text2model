% Facility location / capacitated distribution planning
% Data is embedded as requested.

include "globals.mzn";

int: C = 7;   % distribution centers
int: S = 9;   % stores

set of int: CENTERS = 1..C;
set of int: STORES  = 1..S;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: shipCost =
  [| 3, 3, 5, 4, 3, 5, 2, 4, 2
   | 4, 5, 1, 4, 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4, 3, 4, 4, 1
   | 3, 5, 3, 5, 1, 2, 4, 1, 4
   | 2, 2, 1, 2, 5, 2, 4, 4, 4
   | 4, 5, 3, 1, 4, 2, 4, 2, 2
   | 4, 5, 2, 2, 4, 2, 2, 4, 4 |];

array[STORES] of int: demand = [695, 737, 452, 616, 587, 779, 892, 440, 556];

array[CENTERS] of int: capacity = [814, 864, 1320, 1952, 1447, 1886, 1962];

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: x;  % units shipped from center c to store s

% Demand satisfaction (each store fully supplied)
constraint forall(s in STORES)(
  sum(c in CENTERS)(x[c,s]) = demand[s]
);

% Capacity constraints, and linking shipments to open/closed decisions
constraint forall(c in CENTERS)(
  sum(s in STORES)(x[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective: opening costs + shipping costs
var int: totalOpenCost = sum(c in CENTERS)(openCost[c] * bool2int(open[c]));
var int: totalShipCost = sum(c in CENTERS, s in STORES)(shipCost[c,s] * x[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Shipping cost = ", show(totalShipCost), "\n",
  "Open centers = ", show([c | c in CENTERS where fix(open[c]) = true]), "\n",
  "Open flags = ", show(open), "\n",
  "Shipments x[c,s] (rows=centers, cols=stores):\n",
  concat([ concat([ if s=1 then "" else " " endif ++ show(x[c,s])
                    | s in STORES ]) ++ "\n"
           | c in CENTERS ])
];