int: M = 5;
int: N = 9;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[DC] of int: cap = [1825, 1821, 1365, 1929, 1502];
array[ST] of int: demand = [739, 491, 457, 628, 413, 398, 573, 409, 480];

array[DC, ST] of int: transCost = array2d(DC, ST, [
  5, 2, 3, 4, 6, 7, 5, 4, 5,
  2, 4, 6, 4, 3, 5, 7, 6, 5,
  3, 6, 2, 5, 4, 3, 4, 7, 6,
  4, 5, 4, 2, 6, 4, 3, 5, 4,
  6, 3, 5, 6, 2, 4, 5, 3, 4
]);

int: totalDemand = sum(s in ST)(demand[s]);

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: x;

var int: totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transCost[d, s] * x[d, s]);

constraint forall(s in ST) (
  sum(d in DC)(x[d, s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(x[d, s]) <= cap[d] * bool2int(open[d])
);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n",
  "x=\n",
  show([ [ x[d,s] | s in ST ] | d in DC ]),
  "\n"
];