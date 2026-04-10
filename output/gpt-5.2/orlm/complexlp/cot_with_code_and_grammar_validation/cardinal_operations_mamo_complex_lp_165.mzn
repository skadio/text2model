int: N = 6;
int: M = 4;

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[DC, ST] of int: transpCost =
  array2d(DC, ST,
    [ 2, 3, 3, 3,
      5, 4, 3, 5,
      2, 4, 2, 4,
      5, 1, 4, 2,
      5, 4, 1, 1,
      3, 3, 2, 4 ]);

array[ST] of int: demand = [589, 962, 966, 643];
array[DC] of int: cap = [1631, 1954, 1446, 820, 1640, 966];

int: totalDemand = sum(s in ST)(demand[s]);

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

constraint forall(s in ST) (
  sum(i in DC)(ship[i, s]) = demand[s]
);

constraint forall(i in DC) (
  sum(s in ST)(ship[i, s]) <= cap[i] * bool2int(open[i])
);

var int: totalCost =
  sum(i in DC)(openCost[i] * bool2int(open[i])) +
  sum(i in DC, s in ST)(transpCost[i, s] * ship[i, s]);

solve minimize totalCost;

output [ show(totalCost) ];