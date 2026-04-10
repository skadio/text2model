int: N = 7;
int: M = 5;

set of int: Centers = 1..N;
set of int: Stores  = 1..M;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[Centers] of int: cap      = [1697, 891, 1755, 1308, 1575, 834, 1005];

array[Stores] of int: demand = [715, 413, 641, 745, 964];

array[Centers, Stores] of int: transCost =
[|
  3, 3, 5, 4, 3 |
  5, 2, 4, 2, 4 |
  5, 1, 4, 2, 5 |
  4, 1, 1, 3, 3 |
  2, 4, 4, 3, 4 |
  4, 1, 3, 5, 3 |
  5, 1, 2, 4, 1
|];

int: totalDemand = sum(s in Stores)(demand[s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var int: totalCost;

constraint
  forall(s in Stores)(
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= cap[c] * bool2int(open[c])
  );

constraint
  totalCost =
    sum(c in Centers)(openCost[c] * bool2int(open[c]))
  + sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;