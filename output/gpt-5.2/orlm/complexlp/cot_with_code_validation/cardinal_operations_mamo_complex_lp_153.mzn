% Facility location / transportation with capacities
% Data embedded as requested

int: nCenters = 4;
int: nStores  = 6;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000];
array[CENTERS] of int: capacity = [1631, 1954, 1446, 820];

array[STORES] of int: demand = [910, 875, 589, 962, 966, 643];

array[CENTERS, STORES] of int: shipCost =
  [| 5, 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3 |];

int: totalDemand = sum(s in STORES)(demand[s]);
int: maxShipCost = max([ shipCost[c,s] | c in CENTERS, s in STORES ]);
int: maxOpenCost = sum(c in CENTERS)(openCost[c]);
int: maxObj      = maxOpenCost + totalDemand * maxShipCost;

% Decision variables
array[CENTERS] of var bool: open;

% Tighten x upper bounds to avoid huge domains -> avoids timeout
array[CENTERS, STORES] of var 0..max(demand): x;

var 0..maxObj: totalCost;

% Demand satisfaction
constraint forall(s in STORES)(
  sum(c in CENTERS)(x[c,s]) = demand[s]
);

% Capacity and opening linking
constraint forall(c in CENTERS)(
  sum(s in STORES)(x[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective definition
constraint totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(shipCost[c,s] * x[c,s]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show([ bool2int(open[c]) | c in CENTERS ]), "\n",
  "shipments x (centers x stores):\n",
  concat([ concat([ show(x[c,s]) ++ if s==nStores then "\n" else " " endif
                  | s in STORES ])
         | c in CENTERS ])
];