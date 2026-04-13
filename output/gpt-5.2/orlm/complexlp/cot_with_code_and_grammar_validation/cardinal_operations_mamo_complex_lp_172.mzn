int: M = 8;
int: N = 9;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[DC, ST] of int: transCost =
[|
  2, 3, 4, 5, 2, 3, 4, 5, 2 |
  1, 2, 3, 4, 5, 1, 2, 3, 4 |
  1, 1, 2, 2, 3, 3, 4, 4, 1 |
  5, 4, 3, 2, 1, 5, 4, 3, 2 |
  2, 2, 3, 3, 4, 4, 5, 5, 1 |
  3, 4, 5, 1, 2, 3, 4, 5, 1 |
  2, 5, 2, 5, 2, 5, 2, 5, 2 |
  1, 3, 5, 2, 4, 1, 3, 5, 2
|];

array[ST] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];
array[DC] of int: capacity = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

int: totalDemand = sum(j in ST)(demand[j]);

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

constraint forall(j in ST) (
  sum(i in DC)(ship[i,j]) = demand[j]
);

constraint forall(i in DC) (
  sum(j in ST)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

var int: totalCost =
  sum(i in DC)(openCost[i] * bool2int(open[i])) +
  sum(i in DC, j in ST)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[i]) | i in DC]), "\n"
];