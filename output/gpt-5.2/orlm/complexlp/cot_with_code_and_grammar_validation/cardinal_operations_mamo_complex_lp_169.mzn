int: NCenters = 6;
int: NStores = 8;

set of int: Centers = 1..NCenters;
set of int: Stores = 1..NStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[Centers, Stores] of int: transCost =
  [| 2, 3, 1, 4, 3, 2, 4, 5
   | 2, 4, 3, 2, 5, 4, 3, 2
   | 5, 4, 2, 3, 1, 2, 3, 4
   | 4, 3, 5, 2, 4, 1, 2, 3
   | 5, 1, 4, 3, 2, 5, 1, 2
   | 1, 2, 3, 4, 2, 3, 1, 4
  |];

array[Stores] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[Centers] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(s in Stores)(demand[s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

constraint
  forall(s in Stores) (
    sum(c in Centers)(ship[c, s]) = demand[s]
  );

constraint
  forall(c in Centers) (
    sum(s in Stores)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

constraint
  forall(c in Centers, s in Stores) (
    ship[c, s] <= demand[s] * bool2int(open[c])
  );

solve minimize
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(transCost[c, s] * ship[c, s]);

output [
  "Total cost = ", show(
    sum(c in Centers)(openCost[c] * bool2int(open[c])) +
    sum(c in Centers, s in Stores)(transCost[c, s] * ship[c, s])
  ), "\n",
  "Open centers = ", show([bool2int(open[c]) | c in Centers]), "\n"
];