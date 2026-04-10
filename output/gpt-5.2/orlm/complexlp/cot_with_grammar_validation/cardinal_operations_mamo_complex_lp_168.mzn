int: M = 4;
int: N = 4;

set of int: DC = 1..M;
set of int: OUT = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000];
array[DC] of int: capacity = [1547, 1656, 1274, 1882];
array[OUT] of int: demand = [859, 713, 421, 652];

array[DC, OUT] of int: transCost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

int: totalDemand = sum(o in OUT)(demand[o]);
int: maxUnitTransCost = max([transCost[d,o] | d in DC, o in OUT]);
int: maxOpenCost = max([openCost[d] | d in DC]);
int: upperObj = totalDemand * maxUnitTransCost + M * maxOpenCost;

array[DC] of var 0..1: open;
array[DC, OUT] of var 0..max(demand): ship;

constraint forall(o in OUT) (
  sum(d in DC)(ship[d,o]) = demand[o]
);

constraint forall(d in DC) (
  sum(o in OUT)(ship[d,o]) <= capacity[d] * open[d]
);

var 0..upperObj: totalCost =
  sum(d in DC)(openCost[d] * open[d]) +
  sum(d in DC, o in OUT)(transCost[d,o] * ship[d,o]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];