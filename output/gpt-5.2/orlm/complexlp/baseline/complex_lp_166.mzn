int: nCenters = 9;
int: nStores  = 6;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[CENTERS, STORES] of int: shipCost =
[
| 3, 5, 4, 3, 5, 2 |
| 4, 2, 4, 5, 1, 4 |
| 2, 5, 4, 1, 1, 3 |
| 3, 2, 4, 4, 3, 4 |
| 4, 1, 3, 5, 3, 5 |
| 1, 2, 4, 1, 4, 2 |
| 2, 1, 2, 5, 2, 4 |
| 4, 4, 4, 5, 3, 1 |
| 4, 2, 4, 2, 2, 4 |
];

array[STORES] of int: demand = [876, 801, 955, 561, 601, 669];

array[CENTERS] of int: capacity = [1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591];

int: totalDemand = sum(s in STORES)(demand[s]);

array[CENTERS, STORES] of var 0..totalDemand: flow;
array[CENTERS] of var bool: open;

constraint
  forall(s in STORES)(
    sum(c in CENTERS)(flow[c,s]) = demand[s]
  );

constraint
  forall(c in CENTERS)(
    sum(s in STORES)(flow[c,s]) <= capacity[c] * bool2int(open[c])
  );

var int: totalOpenCost = sum(c in CENTERS)(openCost[c] * bool2int(open[c]));
var int: totalShipCost = sum(c in CENTERS, s in STORES)(shipCost[c,s] * flow[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Minimal total cost = ", show(totalCost), "\n",
  "  Opening cost     = ", show(totalOpenCost), "\n",
  "  Transport cost   = ", show(totalShipCost), "\n",
  "Open centers: ", show([c | c in CENTERS where fix(open[c]) = 1]), "\n",
  "Flows (center->store):\n"
] ++
[
  "Center " ++ show(c) ++ ": " ++ show([flow[c,s] | s in STORES]) ++ "\n"
  | c in CENTERS
];