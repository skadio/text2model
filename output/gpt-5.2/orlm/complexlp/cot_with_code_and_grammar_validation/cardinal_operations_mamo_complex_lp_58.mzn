int: N = 5;
set of int: R = 1..N;

array[R] of int: supply = [133, 189, 446, 346, 184];
array[R] of int: demand = [146, 270, 313, 102, 412];

array[R, R] of int: cost =
  [| 0, 24, 32, 44, 46
   | 41, 0,  6, 11, 49
   | 40, 10, 0, 40, 45
   | 22, 22, 34, 0,  1
   | 46, 14, 35, 36, 0
  |];

int: total_supply = sum(r in R)(supply[r]);
int: total_demand = sum(r in R)(demand[r]);

constraint total_supply >= total_demand;

array[R, R] of var 0..total_supply: x;

constraint forall(i in R)(x[i,i] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

constraint forall(j in R)(
  sum(i in R)(x[i,j]) >= demand[j]
);

var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "x =\n",
  concat([ concat([ (if j == 1 then "" else " " endif) ++ show(x[i,j]) | j in R ]) ++ "\n" | i in R ])
];