int: N = 7;
int: M = 7;

set of int: Centers = 1..N;
set of int: Stores = 1..M;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[Centers, Stores] of int: transCost =
  [| 3, 3, 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1, 3
   | 5, 3, 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2, 5, 2
   | 4, 4, 4, 4, 5, 3, 1 |];

array[Stores] of int: demand = [961, 787, 401, 789, 965, 505, 876];
array[Centers] of int: capacity = [1502, 1201, 1529, 961, 1001, 1795, 1069];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxOpenCost = sum(c in Centers)(openCost[c]);
int: maxTransCost = max([transCost[c, s] | c in Centers, s in Stores]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var 0..(maxOpenCost + maxTransCost * totalDemand): totalCost;

constraint
  forall(s in Stores) (
    sum(c in Centers)(ship[c, s]) = demand[s]
  );

constraint
  forall(c in Centers) (
    sum(s in Stores)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

constraint
  totalCost =
    sum(c in Centers)(openCost[c] * bool2int(open[c])) +
    sum(c in Centers, s in Stores)(transCost[c, s] * ship[c, s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in Centers]), "\n",
  "ship=\n",
  show([ [ ship[c, s] | s in Stores ] | c in Centers ])
];