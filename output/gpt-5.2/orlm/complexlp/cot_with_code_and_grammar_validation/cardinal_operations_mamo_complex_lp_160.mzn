int: M = 8;
int: N = 5;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[DC, ST] of int: transCost =
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2
  |];

array[ST] of int: demand = [964, 739, 491, 766, 854];
array[DC] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(j in ST)(demand[j]);
int: maxDemand = max([demand[j] | j in ST]);

array[DC] of var bool: open;
array[DC, ST] of var 0..maxDemand: ship;

constraint forall(j in ST) (
  sum(i in DC)(ship[i, j]) = demand[j]
);

constraint forall(i in DC) (
  sum(j in ST)(ship[i, j]) <= capacity[i] * bool2int(open[i])
);

constraint forall(i in DC) (
  open[i] -> (sum(j in ST)(ship[i, j]) >= 1)
);

constraint sum(i in DC)(capacity[i] * bool2int(open[i])) >= totalDemand;

var int: totalCost =
  sum(i in DC)(openCost[i] * bool2int(open[i])) +
  sum(i in DC, j in ST)(transCost[i, j] * ship[i, j]);

solve minimize totalCost;

output
  [ "totalCost=", show(totalCost), "\n",
    "open=", show([bool2int(open[i]) | i in DC]), "\n",
    "ship=\n"
  ]
  ++
  [ concat([show(ship[i, j]) ++ (if i < M then " " else "" endif) | i in DC]) ++ "\n"
    | j in ST
  ];