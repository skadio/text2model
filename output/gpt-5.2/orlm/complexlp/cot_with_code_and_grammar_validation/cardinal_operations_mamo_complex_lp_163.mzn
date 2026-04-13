int: nDC = 6;
int: nS  = 9;

set of int: DC = 1..nDC;
set of int: S  = 1..nS;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[DC, S] of int: shipCost =
[|
  2, 3, 1, 4, 5, 2, 3, 4, 2,
  4, 2, 3, 1, 4, 5, 2, 3, 4,
  1, 1, 2, 3, 4, 5, 1, 2, 4,
  4, 1, 3, 2, 5, 4, 2, 1, 4,
  1, 4, 2, 3, 1, 5, 4, 2, 4,
  4, 4, 4, 4, 4, 4, 4, 4, 4
|];

array[S] of int: demand = [401, 582, 623, 711, 844, 512, 955, 678, 734];

array[DC] of int: capacity = [1795, 1435, 1650, 1520, 1340, 1095];

int: maxCap = max(i in DC)(capacity[i]);

array[DC] of var 0..1: open;
array[DC, S] of var 0..maxCap: x;

constraint forall(j in S) (
  sum(i in DC)(x[i,j]) = demand[j]
);

constraint forall(i in DC) (
  sum(j in S)(x[i,j]) <= capacity[i] * open[i]
);

var int: totalCost =
  sum(i in DC)(openCost[i] * open[i]) +
  sum(i in DC, j in S)(shipCost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "x=", show(x), "\n"
];