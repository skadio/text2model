include "globals.mzn";

int: M = 4;
int: N = 8;

set of int: CENTERS = 1..M;
set of int: STORES = 1..N;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000];
array[CENTERS] of int: capacity = [1041, 1576, 1364, 1697];
array[STORES] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];

array[CENTERS, STORES] of int: transCost =
  [| 5, 5, 2, 3, 3, 3, 5, 4
   | 3, 5, 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4, 4, 1, 3
  |];

int: totalDemand = sum(s in STORES)(demand[s]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c, s]) = demand[s]
);

constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

constraint forall(c in CENTERS, s in STORES) (
  ship[c, s] <= demand[s] * bool2int(open[c])
);

constraint open[1] >= open[2] /\ open[2] >= open[3] /\ open[3] >= open[4];

var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);

solve minimize totalCost;

output [
  "open = ", show(open), "\n",
  "totalCost = ", show(totalCost), "\n",
  "ship =\n",
  concat([
    concat([
      show(ship[c, s]) ++ if s = N then "\n" else "\t" endif
      | s in STORES
    ])
    | c in CENTERS
  ])
];