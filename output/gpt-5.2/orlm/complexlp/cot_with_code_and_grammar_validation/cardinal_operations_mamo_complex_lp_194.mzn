int: N = 5;
set of int: R = 1..N;

array[R, R] of int: cost = array2d(R, R, [
  0, 10, 12, 17, 34,
  10, 0, 18, 8, 46,
  12, 18, 0, 9, 27,
  17, 8, 9, 0, 20,
  34, 46, 27, 20, 0
]);

array[R] of int: current = [115, 385, 410, 480, 610];
array[R] of int: needed  = [200, 500, 800, 200, 300];

array[R] of int: req = [needed[i] - current[i] | i in R];

set of int: S = {i | i in R where req[i] < 0};
set of int: D = {j | j in R where req[j] > 0};

array[S] of int: supply = array1d(S, [ -req[i] | i in S ]);
array[D] of int: demand = array1d(D, [  req[j] | j in D ]);

int: max_supply = max(i in S)(supply[i]);

array[S, D] of var 0..max_supply: x;

constraint forall(i in S)(
  sum(j in D)(x[i,j]) = supply[i]
);

constraint forall(j in D)(
  sum(i in S)(x[i,j]) = demand[j]
);

solve
  :: int_search([x[i,j] | i in S, j in D], first_fail, indomain_min, complete)
  minimize sum(i in S, j in D)(cost[i,j] * x[i,j]);

output
  [
    "min_cost = ", show(sum(i in S, j in D)(cost[i,j] * x[i,j])), "\n",
    "shipments (from surplus i to deficit j):\n"
  ]
  ++
  [
    "x[" ++ show(i) ++ "," ++ show(j) ++ "] = " ++ show(x[i,j]) ++ "\n"
    | i in S, j in D
  ];