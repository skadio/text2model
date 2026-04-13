include "globals.mzn";

int: M = 9;
int: N = 7;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[ST] of int: demand = [695, 737, 452, 616, 587, 779, 892];

array[DC] of int: capacity = [1864, 1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

array[DC, ST] of int: transCost = array2d(DC, ST, [
  3, 5, 7, 6, 8, 5, 9,
  2, 4, 6, 5, 7, 4, 8,
  4, 6, 5, 7, 6, 6, 7,
  5, 3, 6, 4, 5, 7, 6,
  6, 5, 4, 6, 3, 5, 4,
  3, 4, 5, 3, 4, 3, 5,
  7, 6, 5, 6, 7, 5, 6,
  5, 7, 6, 5, 6, 4, 7,
  4, 5, 7, 6, 5, 6, 4
]);

int: totalDemand = sum(s in ST)(demand[s]);

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

constraint forall(s in ST) (
  sum(i in DC)(ship[i, s]) = demand[s]
);

constraint forall(i in DC) (
  sum(s in ST)(ship[i, s]) <= capacity[i] * bool2int(open[i])
);

var int: totalCost =
  sum(i in DC)(openCost[i] * bool2int(open[i])) +
  sum(i in DC, s in ST)(transCost[i, s] * ship[i, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[i]) | i in DC]), "\n",
  "ship=\n", show([ [ ship[i,s] | s in ST ] | i in DC ]), "\n"
];