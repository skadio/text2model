int: M = 6;
int: N = 8;

set of int: CENTERS = 1..M;
set of int: STORES = 1..N;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES, [
    2, 3, 1, 3, 4, 2, 4, 5,
    2, 4, 2, 1, 2, 3, 2, 2,
    5, 4, 3, 2, 4, 5, 3, 4,
    4, 3, 2, 4, 3, 2, 5, 3,
    5, 1, 2, 3, 2, 4, 3, 2,
    1, 2, 3, 4, 2, 1, 2, 4
  ]);

array[STORES] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[CENTERS] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(s in STORES)(demand[s]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c, s]) = demand[s]
);

constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n"
];