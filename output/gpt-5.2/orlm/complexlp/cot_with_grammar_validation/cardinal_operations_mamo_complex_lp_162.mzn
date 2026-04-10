int: nCenters = 7;
int: nStores = 4;

set of int: CENTERS = 1..nCenters;
set of int: STORES = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost =
  [| 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1
   | 4, 2, 5, 4
   | 1, 1, 3, 3
   | 2, 4, 4, 3
   | 4, 4, 1, 3
  |];

array[STORES] of int: demand = [884, 420, 566, 673];

array[CENTERS] of int: capacity = [1187, 1400, 1115, 813, 1041, 1576, 1364];

int: totalDemand = sum(s in STORES)(demand[s]);
int: maxTransCost = max([transCost[c,s] | c in CENTERS, s in STORES]);
int: maxTotalCost = sum(c in CENTERS)(openCost[c]) + totalDemand * maxTransCost;

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

var 0..maxTotalCost: totalCost;

constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

constraint totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show(open), "\n",
  "ship = ", show(ship), "\n"
];