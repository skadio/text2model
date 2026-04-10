int: nCenters = 7;
int: nStores = 7;

set of int: CENTERS = 1..nCenters;
set of int: STORES = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: shipCost =
  [| 3, 3, 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1, 3
   | 5, 3, 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2, 5, 2
   | 4, 4, 4, 4, 5, 3, 1 |];

array[STORES] of int: demand = [961, 787, 401, 789, 965, 505, 876];
array[CENTERS] of int: capacity = [1502, 1201, 1529, 961, 1001, 1795, 1069];

int: totalDemand = sum(s in STORES)(demand[s]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: flow;

constraint forall(s in STORES) (
  sum(c in CENTERS)(flow[c, s]) = demand[s]
);

constraint forall(c in CENTERS) (
  sum(s in STORES)(flow[c, s]) <= capacity[c] * bool2int(open[c])
);

var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(shipCost[c, s] * flow[c, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "flow=\n",
  show([ [ flow[c, s] | s in STORES ] | c in CENTERS ]), "\n"
];