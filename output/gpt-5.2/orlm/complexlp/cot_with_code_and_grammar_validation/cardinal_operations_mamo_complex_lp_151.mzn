int: M = 5;
int: N = 6;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[DC] of int: cap = [1400, 1115, 813, 1041, 1576];

array[ST] of int: demand = [530, 884, 420, 566, 673, 787];

array[DC, ST] of int: transCost =
  [| 5, 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4, 2
   | 4, 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1
  |];

int: totalDemand = sum(s in ST)(demand[s]);
int: maxTrans = max([transCost[d,s] | d in DC, s in ST]);
int: maxShipCost = totalDemand * maxTrans;
int: maxOpenCost = sum(d in DC)(openCost[d]);
int: maxTotalCost = maxOpenCost + maxShipCost;

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;
var 0..maxTotalCost: totalCost;

constraint forall(s in ST) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

constraint forall(d in DC, s in ST) (
  ship[d,s] <= demand[s] * bool2int(open[d])
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d,s]) <= cap[d] * bool2int(open[d])
);

constraint totalCost =
    sum(d in DC)(openCost[d] * bool2int(open[d]))
  + sum(d in DC, s in ST)(transCost[d,s] * ship[d,s]);

solve minimize totalCost;

output
  [ "open = ", show(open), "\n",
    "totalCost = ", show(totalCost), "\n",
    "ship =\n"
  ]
  ++
  [ concat([ show(ship[d,s]) ++ (if s == N then "\n" else "\t" endif) | s in ST ])
    | d in DC
  ];