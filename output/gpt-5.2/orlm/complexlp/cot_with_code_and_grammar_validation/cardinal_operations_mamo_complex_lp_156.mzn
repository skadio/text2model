int: N = 7;
int: M = 6;

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[DC] of int: cap = [1575, 834, 1005, 1904, 1825, 1821, 1365];

array[ST] of int: demand = [739, 491, 766, 854, 827, 908];

array[DC, ST] of int: transCost =
[| 3, 3, 5, 4, 3, 5
 | 2, 4, 2, 4, 5, 1
 | 4, 2, 5, 4, 1, 1
 | 3, 3, 2, 4, 4, 3
 | 4, 4, 1, 3, 5, 3
 | 5, 1, 2, 4, 1, 4
 | 2, 2, 1, 2, 5, 2
 |];

int: totalDemand = sum(s in ST)(demand[s]);

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

constraint forall(s in ST) (
  sum(d in DC)(ship[d, s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d, s]) <= cap[d] * bool2int(open[d])
);

solve minimize
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transCost[d, s] * ship[d, s]);

output [
  "Total cost = ",
  show(
    sum(d in DC)(openCost[d] * bool2int(open[d])) +
    sum(d in DC, s in ST)(transCost[d, s] * ship[d, s])
  ),
  "\nOpen centers: ",
  show([bool2int(open[d]) | d in DC]),
  "\n"
];