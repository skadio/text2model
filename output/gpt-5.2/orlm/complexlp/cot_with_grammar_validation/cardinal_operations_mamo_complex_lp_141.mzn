int: M = 4;
int: N = 6;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000];

array[DC, ST] of int: trans_cost =
  array2d(DC, ST,
    [ 5, 5, 2, 3, 3, 3,
      5, 4, 3, 5, 2, 4,
      2, 4, 5, 1, 4, 2,
      5, 4, 1, 1, 3, 3 ]);

array[ST] of int: demand = [910, 875, 589, 962, 966, 643];
array[DC] of int: capacity = [1631, 1954, 1446, 820];

int: total_demand = sum(s in ST)(demand[s]);

array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: ship;

var int: total_cost;

constraint forall(s in ST) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

constraint total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(trans_cost[d,s] * ship[d,s]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "open = ", show(open), "\n",
  "ship = ", show(ship), "\n"
];