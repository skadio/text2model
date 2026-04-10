int: N = 5;
int: M = 5;

set of int: CENTERS = 1..N;
set of int: STORES = 1..M;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[CENTERS, STORES] of int: transpCost =
  [| 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1
   | 1, 3, 3, 2, 4 |];

array[STORES] of int: demand = [589, 962, 966, 643, 904];
array[CENTERS] of int: capacity = [1954, 1446, 820, 1640, 966];

int: totalDemand = sum(s in STORES)(demand[s]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transpCost[c, s] * ship[c, s]);

constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c, s]) = demand[s]
);

constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "ship=\n",
  show([ [ ship[c, s] | s in STORES ] | c in CENTERS ]), "\n"
];