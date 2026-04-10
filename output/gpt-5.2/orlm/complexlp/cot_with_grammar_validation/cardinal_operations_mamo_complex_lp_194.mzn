int: N = 5;
set of int: R = 1..N;

array[R, R] of int: cost = [|
  0, 10, 12, 17, 34 |
 10,  0, 18,  8, 46 |
 12, 18,  0,  9, 27 |
 17,  8,  9,  0, 20 |
 34, 46, 27, 20,  0
|];

array[R] of int: supply = [115, 385, 410, 480, 610];
array[R] of int: demand = [200, 500, 800, 200, 300];

array[R] of int: net = [supply[i] - demand[i] | i in R];

set of int: S = {i | i in R where net[i] > 0};
set of int: D = {j | j in R where net[j] < 0};

array[S, D] of var 0..max(supply): x;

var 0..sum(supply) * max([cost[i, j] | i in R, j in R]): total_cost;

constraint forall(i in S) (
  sum(j in D)(x[i, j]) = net[i]
);

constraint forall(j in D) (
  sum(i in S)(x[i, j]) = -net[j]
);

constraint total_cost = sum(i in S, j in D)(cost[i, j] * x[i, j]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n"
];