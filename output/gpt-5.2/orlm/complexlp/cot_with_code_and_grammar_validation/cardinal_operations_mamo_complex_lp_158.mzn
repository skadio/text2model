int: N = 8;
int: M = 8;

set of int: Centers = 1..N;
set of int: Stores = 1..M;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];
array[Centers] of int: capacity = [1980, 814, 864, 1320, 1952, 1447, 1886, 1962];
array[Stores] of int: demand = [695, 737, 452, 616, 587, 779, 892, 440];

array[Centers, Stores] of int: shipCost =
[| 3, 3, 5, 4, 3, 5, 2, 4
 | 2, 4, 5, 1, 4, 2, 5, 4
 | 1, 1, 3, 3, 2, 4, 4, 3
 | 4, 4, 1, 3, 5, 3, 5, 1
 | 2, 4, 1, 4, 2, 2, 1, 2
 | 5, 2, 4, 4, 4, 4, 5, 3
 | 1, 4, 2, 4, 2, 2, 4, 5
 | 2, 2, 4, 2, 2, 4, 4, 1
|];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxCap = max([capacity[c] | c in Centers]);
int: maxShipCost = max([shipCost[c,s] | c in Centers, s in Stores]);

int: totalCostUB = sum(c in Centers)(openCost[c]) + maxShipCost * totalDemand;

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxCap: x;

var 0..totalCostUB: totalCost;

constraint forall(s in Stores) (
  sum(c in Centers)(x[c,s]) = demand[s]
);

constraint forall(c in Centers) (
  sum(s in Stores)(x[c,s]) <= capacity[c] * bool2int(open[c])
);

constraint totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(shipCost[c,s] * x[c,s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n"
];