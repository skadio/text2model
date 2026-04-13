int: M = 6;
int: N = 4;

set of int: CENTERS = 1..M;
set of int: STORES = 1..N;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: trans_cost =
  array2d(CENTERS, STORES,
    [ 2,3,3,3,
      5,4,3,5,
      2,4,2,4,
      5,1,4,2,
      5,4,1,1,
      3,3,2,4 ]);

array[STORES] of int: demand = [589, 962, 966, 643];
array[CENTERS] of int: capacity = [1631, 1954, 1446, 820, 1640, 966];

int: total_demand = sum(s in STORES)(demand[s]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..total_demand: ship;

constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

var int: total_cost =
  sum(c in CENTERS)(open_cost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(trans_cost[c,s] * ship[c,s]);

solve minimize total_cost;

output [show(total_cost)];