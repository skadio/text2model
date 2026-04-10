int: N = 8;
int: M = 8;

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[DC, ST] of int: transCost = array2d(DC, ST, [
  3, 5, 4, 6, 3, 4, 5, 4,
  2, 4, 3, 5, 2, 3, 4, 4,
  4, 3, 5, 4, 4, 5, 3, 6,
  5, 6, 4, 3, 5, 4, 6, 5,
  3, 4, 6, 5, 3, 6, 4, 5,
  4, 5, 3, 4, 4, 3, 5, 4,
  6, 4, 5, 6, 5, 4, 3, 5,
  5, 6, 4, 5, 6, 5, 4, 3
]);

array[ST] of int: demand = [695, 612, 721, 498, 533, 689, 472, 440];
array[DC] of int: capacity = [1980, 2020, 1750, 1900, 1830, 1680, 2100, 1962];

int: totalDemand = sum(s in ST)(demand[s]);

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

constraint forall(s in ST) (
  sum(d in DC)(ship[d, s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d, s]) <= capacity[d] * bool2int(open[d])
);

var int: totalOpenCost = sum(d in DC)(openCost[d] * bool2int(open[d]));
var int: totalTransCost = sum(d in DC, s in ST)(transCost[d, s] * ship[d, s]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];