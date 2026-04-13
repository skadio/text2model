int: M = 5;
int: N = 6;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[DC] of int: capacity = [1400, 1115, 813, 1041, 1576];

array[ST] of int: demand = [530, 884, 420, 566, 673, 787];

array[DC, ST] of int: transCost =
  [| 5, 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4, 2
   | 4, 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1 |];

int: maxDemand = max(s in ST)(demand[s]);
int: maxCost = max(d in DC, s in ST)(transCost[d,s]);

array[DC] of var bool: open;
array[DC, ST] of var 0..maxDemand: ship;

var int: totalCost;

constraint forall(s in ST)(
  sum(d in DC)(ship[d,s]) = demand[s]
);

constraint forall(d in DC)(
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

constraint forall(d in DC, s in ST)(
  ship[d,s] <= demand[s] * bool2int(open[d])
);

constraint totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transCost[d,s] * ship[d,s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n",
  "ship=\n",
  concat([ concat([ show(ship[d,s]) ++ if s==N then "\n" else " " endif | s in ST ]) | d in DC ])
];