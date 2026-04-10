% Facility Location / Capacitated Distribution Centers with shipping
% All data embedded as requested.

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
 | 4, 4, 3, 4, 4, 1
 |];

array[Stores] of int: demand = [530, 884, 420, 566, 673, 787];
array[Centers] of int: capacity = [1400, 1115, 813, 1041, 1576];

int: totalDemand = sum(s in Stores)(demand[s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: flow; % units shipped from center c to store s

% Demand satisfaction
constraint forall(s in Stores)(
  sum(c in Centers)(flow[c,s]) = demand[s]
);

% Capacity constraints (only if open)
constraint forall(c in Centers)(
  sum(s in Stores)(flow[c,s]) <= capacity[c] * bool2int(open[c])
);

var int: totalOpenCost = sum(c in Centers)(openCost[c] * bool2int(open[c]));
var int: totalShipCost = sum(c in Centers, s in Stores)(shipCost[c,s] * flow[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "  Opening cost      = ", show(totalOpenCost), "\n",
  "  Transport cost    = ", show(totalShipCost), "\n",
  "Open centers: ", show([c | c in Centers where fix(open[c]) = true]), "\n",
  "Flows (center x store):\n",
  concat([ concat([ if s=1 then "" else " " endif ++ show(flow[c,s]) | s in Stores ]) ++ "\n" | c in Centers ])
];