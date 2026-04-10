int: M = 6;
int: N = 8;

set of int: Centers = 1..M;
set of int: Stores = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[Centers, Stores] of int: transCost =
[| 2, 3, 1, 3, 4, 2, 5, 5
 | 2, 4, 2, 1, 2, 4, 2, 2
 | 5, 4, 5, 2, 5, 2, 3, 4
 | 4, 3, 3, 4, 3, 5, 4, 3
 | 5, 1, 2, 5, 1, 2, 4, 2
 | 1, 2, 3, 4, 2, 1, 2, 4
|];

array[Stores] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];

array[Centers] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxCap = max(c in Centers)(capacity[c]);
int: maxTransCost = max(c in Centers, s in Stores)(transCost[c, s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var 0..(sum(c in Centers)(openCost[c]) + totalDemand * maxTransCost): totalCost;

constraint forall(s in Stores) (
  sum(c in Centers)(ship[c, s]) = demand[s]
);

constraint forall(c in Centers) (
  sum(s in Stores)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

constraint totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(transCost[c, s] * ship[c, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];