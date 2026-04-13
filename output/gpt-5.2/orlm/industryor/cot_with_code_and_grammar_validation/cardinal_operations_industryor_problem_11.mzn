include "globals.mzn";

int: N = 6;
set of int: T = 1..N;

array[T] of int: volume = [1500, 2500, 4000, 6000, 9000, 12000];
array[T] of int: demand = [500, 550, 700, 900, 400, 300];
array[T] of int: var_cost = [5, 8, 10, 12, 16, 18];

int: setup_cost = 1200;

int: total_demand = sum(i in T)(demand[i]);

array[T, T] of bool: can_sub = array2d(T, T, [j >= i | i in T, j in T]);

array[T] of var 0..total_demand: prod;
array[T] of var bool: use_equipment;
array[T, T] of var 0..total_demand: alloc;

constraint forall(i in T, j in T where not can_sub[i, j]) (
  alloc[i, j] = 0
);

constraint forall(i in T) (
  sum(j in T)(alloc[i, j]) = demand[i]
);

constraint forall(j in T) (
  sum(i in T)(alloc[i, j]) <= prod[j]
);

constraint forall(j in T) (
  prod[j] <= total_demand * bool2int(use_equipment[j])
);

constraint forall(j in T) (
  prod[j] >= bool2int(use_equipment[j])
);

solve minimize
  sum(j in T)(var_cost[j] * prod[j]) +
  sum(j in T)(setup_cost * bool2int(use_equipment[j]));

output [
  "total_cost=", show(
    sum(j in T)(var_cost[j] * prod[j]) +
    sum(j in T)(setup_cost * bool2int(use_equipment[j]))
  ), "\n",
  "prod=", show(prod), "\n",
  "use_equipment=", show([bool2int(use_equipment[j]) | j in T]), "\n",
  "alloc=\n",
  concat([
    concat([
      show(alloc[i, j]) ++ if j == N then "\n" else " " endif
      | j in T
    ])
    | i in T
  ])
];