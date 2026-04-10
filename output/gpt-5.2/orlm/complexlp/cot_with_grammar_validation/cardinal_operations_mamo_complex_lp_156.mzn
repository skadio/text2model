int: NCenters = 7;
int: NStores = 6;

array[1..NCenters] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[1..NCenters] of int: capacity = [1575, 834, 1005, 1904, 1825, 1821, 1365];
array[1..NStores] of int: demand = [739, 491, 766, 854, 827, 908];

array[1..NCenters, 1..NStores] of int: transCost =
[|
  3, 3, 5, 4, 3, 5 |
  2, 4, 2, 4, 5, 1 |
  4, 2, 5, 4, 1, 1 |
  3, 3, 2, 4, 4, 3 |
  4, 4, 1, 3, 5, 3 |
  5, 1, 2, 4, 1, 4 |
  2, 2, 1, 2, 5, 2
|];

int: totalDemand = sum(s in 1..NStores)(demand[s]);

array[1..NCenters] of var bool: open;
array[1..NCenters, 1..NStores] of var 0..totalDemand: ship;

var int: totalOpenCost;
var int: totalShipCost;
var int: totalCost;

constraint forall(s in 1..NStores)(
  sum(c in 1..NCenters)(ship[c, s]) = demand[s]
);

constraint forall(c in 1..NCenters)(
  sum(s in 1..NStores)(ship[c, s]) <= capacity[c]
);

constraint forall(c in 1..NCenters, s in 1..NStores)(
  ship[c, s] <= demand[s] * bool2int(open[c])
);

constraint totalOpenCost = sum(c in 1..NCenters)(openCost[c] * bool2int(open[c]));
constraint totalShipCost = sum(c in 1..NCenters, s in 1..NStores)(transCost[c, s] * ship[c, s]);
constraint totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "totalOpenCost=", show(totalOpenCost), "\n",
  "totalShipCost=", show(totalShipCost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];