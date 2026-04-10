int: M = 8;
int: N = 9;

set of int: Centers = 1..M;
set of int: Stores = 1..N;

array[Centers] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[Centers, Stores] of int: transCost =
  array2d(Centers, Stores, [
    3, 3, 5, 4, 3, 5, 2, 4, 2,
    4, 5, 1, 4, 2, 5, 4, 1, 1,
    3, 3, 2, 4, 4, 3, 4, 4, 1,
    3, 5, 3, 5, 1, 2, 4, 1, 4,
    2, 2, 1, 2, 5, 2, 4, 4, 4,
    4, 5, 3, 1, 4, 2, 4, 2, 2,
    4, 5, 2, 2, 4, 2, 2, 4, 4,
    1, 5, 5, 2, 5, 2, 1, 4, 4
  ]);

array[Stores] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];
array[Centers] of int: capacity = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

int: totalDemand = sum(s in Stores)(demand[s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var int: totalCost;

constraint forall(s in Stores) (
  sum(c in Centers)(ship[c, s]) = demand[s]
);

constraint forall(c in Centers) (
  sum(s in Stores)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

constraint totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(transCost[c, s] * ship[c, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in Centers]), "\n"
];