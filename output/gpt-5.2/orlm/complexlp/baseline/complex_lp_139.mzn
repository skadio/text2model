% Facility location / distribution planning with opening costs and shipping costs
% All data embedded as requested.

int: nCenters = 5;
int: nStores  = 5;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[Centers, Stores] of int: shipCost = array2d(Centers, Stores, [
  5, 2, 3, 3, 3,
  5, 4, 3, 5, 2,
  4, 2, 4, 5, 1,
  4, 2, 5, 4, 1,
  1, 3, 3, 2, 4
]);

array[Stores] of int: demand = [589, 962, 966, 643, 904];
array[Centers] of int: capacity = [1954, 1446, 820, 1640, 966];

int: totalDemand = sum(Stores)(demand[s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: x; % shipped units from center c to store s

% Demand satisfaction
constraint forall(s in Stores) (
  sum(c in Centers)(x[c,s]) = demand[s]
);

% Capacity and linking to open decision
constraint forall(c in Centers) (
  sum(s in Stores)(x[c,s]) <= capacity[c] * bool2int(open[c])
);

var int: totalOpenCost = sum(c in Centers)(openCost[c] * bool2int(open[c]));
var int: totalShipCost = sum(c in Centers, s in Stores)(shipCost[c,s] * x[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Minimum total cost = ", show(totalCost), "\n",
  "  Opening cost      = ", show(totalOpenCost), "\n",
  "  Transport cost    = ", show(totalShipCost), "\n\n",
  "Opened centers (1=open, 0=closed):\n",
  concat([ "  Center ", show(c), ": ", show(bool2int(open[c])), "\n" | c in Centers ]),
  "\nShipments x[c,s] (units):\n",
  concat([ concat([ "  C", show(c), "->S", show(s), ": ", show(x[c,s]), "\n"
                  | s in Stores ]) | c in Centers ])
];