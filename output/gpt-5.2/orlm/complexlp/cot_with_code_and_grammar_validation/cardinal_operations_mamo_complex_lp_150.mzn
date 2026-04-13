int: F = 7;
int: S = 9;

set of int: FC = 1..F;
set of int: ST = 1..S;

array[FC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[ST] of int: demand = [440, 892, 645, 781, 503, 699, 812, 577, 734];
array[FC] of int: cap = [814, 1962, 1220, 1500, 1100, 980, 1400];

array[FC, ST] of int: transCost =
  array2d(FC, ST, [
    2, 4, 3, 5, 1, 2, 4, 3, 5,
    3, 2, 4, 1, 5, 3, 2, 4, 1,
    5, 3, 2, 4, 1, 5, 3, 2, 4,
    1, 5, 3, 2, 4, 1, 5, 3, 2,
    4, 1, 5, 3, 2, 4, 1, 5, 3,
    2, 3, 1, 5, 4, 2, 3, 1, 5,
    3, 5, 4, 2, 1, 3, 5, 4, 2
  ]);

int: totalDemand = sum(j in ST)(demand[j]);

array[FC] of var bool: open;
array[FC, ST] of var 0..totalDemand: ship;

var int: totalCost =
  sum(i in FC)(openCost[i] * bool2int(open[i])) +
  sum(i in FC, j in ST)(transCost[i, j] * ship[i, j]);

constraint forall(j in ST) (
  sum(i in FC)(ship[i, j]) = demand[j]
);

constraint forall(i in FC) (
  sum(j in ST)(ship[i, j]) <= cap[i] * bool2int(open[i])
);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];