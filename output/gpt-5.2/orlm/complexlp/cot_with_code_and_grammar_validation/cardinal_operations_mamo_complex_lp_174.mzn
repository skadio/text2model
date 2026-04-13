int: N = 8;
int: M = 5;

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];
array[DC] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];
array[ST] of int: demand = [964, 739, 491, 766, 854];

array[DC, ST] of int: transCost =
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2 |];

array[DC] of var bool: open;

int: maxDemand = max([demand[s] | s in ST]);
array[DC, ST] of var 0..maxDemand: ship;

constraint forall(s in ST) (
  sum(d in DC)(ship[d, s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d, s]) <= capacity[d] * bool2int(open[d])
);

var int: total_cost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transCost[d, s] * ship[d, s]);

solve minimize total_cost;

output
  [
    "total_cost=", show(total_cost), "\n",
    "open=", show([bool2int(open[d]) | d in DC]), "\n",
    "ship=\n"
  ]
  ++
  [
    concat([show(ship[d, s]) ++ if s < M then "\t" else "\n" endif | s in ST])
    | d in DC
  ];