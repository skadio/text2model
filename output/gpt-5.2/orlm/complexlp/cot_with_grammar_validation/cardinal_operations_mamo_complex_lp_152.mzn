int: N = 4;
int: M = 4;

set of int: Centers = 1..N;
set of int: Stores  = 1..M;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];
array[Centers] of int: capacity = [1547, 1656, 1274, 1882];
array[Stores]  of int: demand   = [859, 713, 421, 652];

array[Centers, Stores] of int: transCost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

int: totalDemand = sum(j in Stores)(demand[j]);
int: maxOpenCost = sum(i in Centers)(openCost[i]);
int: maxTransCost = max([transCost[i,j] | i in Centers, j in Stores]);

array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var 0..(maxOpenCost + totalDemand * maxTransCost): totalCost;

constraint forall(j in Stores)(
  sum(i in Centers)(ship[i,j]) = demand[j]
);

constraint forall(i in Centers)(
  sum(j in Stores)(ship[i,j]) <= capacity[i] * open[i]
);

constraint
  totalCost =
    sum(i in Centers)(openCost[i] * open[i]) +
    sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;