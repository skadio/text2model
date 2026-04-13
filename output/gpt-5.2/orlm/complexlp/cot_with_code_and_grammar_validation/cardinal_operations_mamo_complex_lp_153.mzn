int: nCenters = 4;
int: nStores = 6;

set of int: Centers = 1..nCenters;
set of int: Stores = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];

array[Centers, Stores] of int: shipCost = array2d(Centers, Stores, [
  5, 5, 2, 3, 3, 3,
  5, 4, 3, 5, 2, 4,
  2, 4, 5, 1, 4, 2,
  5, 4, 1, 1, 3, 3
]);

array[Stores] of int: demand = [910, 875, 589, 962, 966, 643];
array[Centers] of int: capacity = [1631, 1954, 1446, 820];

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..max(demand): ship;

var int: totalCost;
constraint
  totalCost =
    sum(c in Centers)(openCost[c] * bool2int(open[c])) +
    sum(c in Centers, s in Stores)(shipCost[c, s] * ship[c, s]);

constraint forall(s in Stores)(
  sum(c in Centers)(ship[c, s]) = demand[s]
);

constraint forall(c in Centers)(
  sum(s in Stores)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show(open), "\n",
  "ship = ", show(ship), "\n"
];