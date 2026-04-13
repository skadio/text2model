int: NDC = 6;
int: NST = 9;

set of int: DC = 1..NDC;
set of int: ST = 1..NST;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[DC, ST] of int: transCost =
[|
  2, 3, 3, 4, 4, 3, 3, 2, 2,
  4, 2, 3, 3, 2, 4, 3, 3, 4,
  1, 1, 2, 3, 4, 4, 3, 2, 4,
  4, 1, 3, 2, 4, 3, 2, 3, 4,
  1, 4, 2, 3, 3, 2, 4, 3, 4,
  4, 4, 3, 2, 3, 4, 2, 3, 4
|];

array[ST] of int: demand = [401, 458, 511, 570, 637, 711, 955, 809, 676];

array[DC] of int: capacity = [1795, 1920, 1650, 1540, 1425, 1095];

int: totalDemand = sum(s in ST)(demand[s]);
int: maxCap = max(d in DC)(capacity[d]);

array[DC] of var 0..1: open;
array[DC, ST] of var 0..maxCap: ship;

constraint forall(s in ST) (
  sum(d in DC)(ship[d, s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d, s]) <= capacity[d] * open[d]
);

constraint sum(d in DC)(capacity[d] * open[d]) >= totalDemand;

var int: totalCost =
  sum(d in DC)(openCost[d] * open[d]) +
  sum(d in DC, s in ST)(transCost[d, s] * ship[d, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n"
];