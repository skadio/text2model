int: M = 5;
int: N = 9;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[ST] of int: demand = [739, 491, 654, 613, 372, 428, 574, 492, 480];

array[DC] of int: capacity = [1825, 1821, 1365, 1929, 1502];

array[DC, ST] of int: shipCost =
[|
  5, 2, 4, 3, 5, 6, 7, 4, 5,
  2, 4, 5, 6, 3, 4, 5, 6, 5,
  4, 3, 2, 5, 6, 3, 4, 5, 6,
  3, 5, 6, 2, 4, 5, 3, 4, 5,
  5, 6, 3, 4, 2, 5, 6, 3, 4
|];

int: totalDemand = sum(s in ST)(demand[s]);

array[DC] of var 0..1: open;
array[DC, ST] of var 0..totalDemand: x;

var int: totalCost;

constraint forall(s in ST) (
  sum(d in DC)(x[d, s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(x[d, s]) <= capacity[d] * open[d]
);

constraint totalCost =
  sum(d in DC)(openCost[d] * open[d]) +
  sum(d in DC, s in ST)(shipCost[d, s] * x[d, s]);

solve minimize totalCost;

output ["totalCost=", show(totalCost), "\n",
        "open=", show(open), "\n",
        "x=", show(x), "\n"];