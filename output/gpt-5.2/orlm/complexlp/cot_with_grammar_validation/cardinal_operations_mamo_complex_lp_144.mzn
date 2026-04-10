int: M = 4;
int: N = 8;

set of int: Centers = 1..M;
set of int: Stores = 1..N;

array[Centers] of int: open_cost = [151000, 192000, 114000, 171000];
array[Centers] of int: capacity  = [1041, 1576, 1364, 1697];

array[Stores] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];

array[Centers, Stores] of int: ship_cost =
[|
  5, 5, 2, 3, 3, 3, 5, 4,
  3, 5, 2, 4, 2, 4, 5, 1,
  4, 2, 5, 4, 1, 1, 3, 3,
  2, 4, 4, 3, 4, 4, 1, 3
|];

int: total_demand = sum(s in Stores)(demand[s]);
int: max_ship_cost = max([ ship_cost[c,s] | c in Centers, s in Stores ]);
int: max_total_cost = sum(c in Centers)(open_cost[c]) + max_ship_cost * total_demand;

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..total_demand: ship;

var 0..max_total_cost: total_cost;

constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

constraint
  total_cost =
    sum(c in Centers)(open_cost[c] * bool2int(open[c])) +
    sum(c in Centers, s in Stores)(ship_cost[c,s] * ship[c,s]);

solve minimize total_cost;

output ["total_cost=" ++ show(total_cost) ++ "\n"];