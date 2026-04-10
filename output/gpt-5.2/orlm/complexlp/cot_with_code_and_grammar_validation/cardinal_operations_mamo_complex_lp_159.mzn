int: M = 9;
int: N = 9;

set of int: Centers = 1..M;
set of int: Stores = 1..N;

array[Centers] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[Stores] of int: demand =
  [871, 462, 538, 898, 992, 791, 818, 688, 778];

array[Centers] of int: capacity =
  [1856, 1600, 1200, 1500, 1400, 1300, 1700, 1100, 1450];

array[Centers, Stores] of int: transCost =
  array2d(Centers, Stores, [
    2, 3, 1, 4, 5, 2, 3, 4, 1,
    3, 2, 4, 1, 2, 5, 4, 3, 2,
    1, 4, 2, 3, 1, 2, 5, 4, 3,
    4, 1, 3, 2, 4, 3, 2, 1, 5,
    5, 2, 1, 4, 3, 1, 4, 2, 3,
    2, 5, 2, 3, 1, 4, 1, 3, 2,
    3, 4, 5, 2, 4, 2, 3, 5, 1,
    4, 3, 4, 1, 2, 3, 2, 1, 5,
    1, 2, 3, 5, 3, 2, 1, 4, 2
  ]);

int: totalDemand = sum(s in Stores)(demand[s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var int: totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(transCost[c, s] * ship[c, s]);

constraint forall(s in Stores) (
  sum(c in Centers)(ship[c, s]) = demand[s]
);

constraint forall(c in Centers) (
  sum(s in Stores)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n"
];