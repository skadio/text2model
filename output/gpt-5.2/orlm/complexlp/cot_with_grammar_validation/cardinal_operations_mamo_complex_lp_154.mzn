int: M = 6;
int: N = 8;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[DC, ST] of int: transCost = array2d(DC, ST, [
  2, 3, 1, 3, 4, 2, 3, 5,
  2, 4, 3, 1, 2, 4, 3, 2,
  5, 4, 2, 4, 3, 1, 2, 4,
  4, 3, 5, 2, 1, 3, 4, 3,
  5, 1, 4, 2, 3, 4, 1, 2,
  1, 2, 3, 4, 2, 1, 3, 4
]);

array[ST] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[DC] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(s in ST)(demand[s]);
int: maxOpenCost = sum(d in DC)(openCost[d]);
int: maxTransCostPerUnit = max([transCost[d, s] | d in DC, s in ST]);
int: maxTransCostTotal = totalDemand * maxTransCostPerUnit;
int: maxTotalCost = maxOpenCost + maxTransCostTotal;

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

var 0..maxTotalCost: totalCost;

constraint forall(s in ST)(
  sum(d in DC)(ship[d, s]) = demand[s]
);

constraint forall(d in DC)(
  sum(s in ST)(ship[d, s]) <= capacity[d] * bool2int(open[d])
);

constraint totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transCost[d, s] * ship[d, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n"
];