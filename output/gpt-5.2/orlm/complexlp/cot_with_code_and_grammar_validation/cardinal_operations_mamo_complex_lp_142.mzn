int: M = 9;
int: N = 6;

set of int: CENTERS = 1..M;
set of int: STORES = 1..N;

array[CENTERS] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[CENTERS] of int: capacity = [
  1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591
];

array[STORES] of int: demand = [
  876, 801, 955, 561, 601, 669
];

array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES, [
    3, 5, 4, 3, 5, 2,
    4, 2, 4, 5, 1, 4,
    2, 5, 4, 1, 1, 3,
    3, 2, 4, 4, 3, 4,
    4, 1, 3, 5, 3, 5,
    1, 2, 4, 1, 4, 2,
    2, 1, 2, 5, 2, 4,
    4, 4, 4, 5, 3, 1,
    4, 2, 4, 2, 2, 4
  ]);

int: totalDemand = sum(s in STORES)(demand[s]);
int: maxShipFromCenter = totalDemand;

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..maxShipFromCenter: ship;

var int: totalCost;

constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "ship =\n",
  concat([
    concat([
      show(ship[c, s]) ++ if s == N then "\n" else " " endif
      | s in STORES
    ])
    | c in CENTERS
  ])
];