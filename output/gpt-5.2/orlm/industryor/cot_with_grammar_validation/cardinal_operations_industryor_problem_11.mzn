int: N = 6;
set of int: T = 1..N;

array[T] of int: volume = [1500, 2500, 4000, 6000, 9000, 12000];
array[T] of int: demand = [500, 550, 700, 900, 400, 300];
array[T] of int: var_cost = [5, 8, 10, 12, 16, 18];

int: setup_cost = 1200;

array[T, T] of bool: can_sub =
  array2d(T, T,
    [ true,  false, false, false, false, false,
      true,  true,  false, false, false, false,
      true,  true,  true,  false, false, false,
      true,  true,  true,  true,  false, false,
      true,  true,  true,  true,  true,  false,
      true,  true,  true,  true,  true,  true
    ]);

int: total_demand = sum(t in T)(demand[t]);

array[T] of var 0..total_demand: prod;
array[T] of var bool: active;
array[T, T] of var 0..total_demand: flow;

var int: total_cost;

constraint forall(i in T, j in T) (
  (not can_sub[i,j]) -> (flow[i,j] = 0)
);

constraint forall(i in T) (
  sum(j in T)(flow[i,j]) = prod[i]
);

constraint forall(j in T) (
  sum(i in T)(flow[i,j]) = demand[j]
);

constraint forall(i in T) (
  prod[i] <= total_demand * bool2int(active[i])
);

constraint forall(i in T) (
  prod[i] >= bool2int(active[i])
);

constraint total_cost =
  sum(i in T)(var_cost[i] * prod[i]) + setup_cost * sum(i in T)(bool2int(active[i]));

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "prod=", show(prod), "\n",
  "active=", show(active), "\n"
];