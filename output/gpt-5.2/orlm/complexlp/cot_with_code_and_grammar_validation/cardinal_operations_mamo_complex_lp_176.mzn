int: N = 7;
int: M = 5;

set of int: Centers = 1..N;
set of int: Stores  = 1..M;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[Centers] of int: capacity = [1697, 891, 1755, 1308, 1575, 834, 1005];
array[Stores]  of int: demand   = [715, 413, 641, 745, 964];

array[Centers, Stores] of int: transpCost =
  array2d(Centers, Stores,
    [
      3, 3, 5, 4, 3,
      5, 2, 4, 2, 4,
      5, 1, 4, 2, 5,
      4, 1, 1, 3, 3,
      2, 4, 4, 3, 4,
      4, 1, 3, 5, 3,
      5, 1, 2, 4, 1
    ]
  );

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxTranspCost = max([transpCost[c,s] | c in Centers, s in Stores]);
int: maxTotalCost = sum(c in Centers)(openCost[c]) + totalDemand * maxTranspCost;

array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..max(demand): ship;

var 0..maxTotalCost: total_cost;

constraint forall(s in Stores) (
  sum(c in Centers)(ship[c,s]) = demand[s]
);

constraint forall(c in Centers) (
  sum(s in Stores)(ship[c,s]) <= capacity[c] * open[c]
);

constraint forall(c in Centers, s in Stores) (
  ship[c,s] <= demand[s] * open[c]
);

constraint total_cost =
  sum(c in Centers)(openCost[c] * open[c]) +
  sum(c in Centers, s in Stores)(transpCost[c,s] * ship[c,s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];