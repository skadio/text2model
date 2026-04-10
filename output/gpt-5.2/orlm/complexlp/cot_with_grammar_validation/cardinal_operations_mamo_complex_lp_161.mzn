int: M = 5;
int: N = 7;

set of int: CENTERS = 1..M;
set of int: STORES = 1..N;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[CENTERS, STORES] of int: shipCost =
[| 5, 2, 3, 3, 3, 5, 4
 | 3, 5, 2, 4, 2, 4, 5
 | 1, 4, 2, 5, 4, 1, 1
 | 3, 3, 2, 4, 4, 3, 4
 | 4, 1, 3, 5, 3, 5, 1
|];

array[STORES] of int: demand = [566, 673, 787, 1000, 715, 413, 641];

array[CENTERS] of int: capacity = [1576, 1364, 1697, 891, 1755];

int: totalDemand = sum(s in STORES)(demand[s]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: x;

constraint forall(s in STORES)(
  sum(c in CENTERS)(x[c, s]) = demand[s]
);

constraint forall(c in CENTERS)(
  sum(s in STORES)(x[c, s]) <= capacity[c] * bool2int(open[c])
);

var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(shipCost[c, s] * x[c, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "x=", show(x), "\n"
];