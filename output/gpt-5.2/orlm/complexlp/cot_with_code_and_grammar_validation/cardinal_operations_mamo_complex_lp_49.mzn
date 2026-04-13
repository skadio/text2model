int: N = 7;
set of int: C = 1..N;

array[C] of int: supply = [97, 458, 473, 380, 34, 399, 163];
array[C] of int: demand = [119, 275, 36, 459, 17, 128, 425];

array[C, C] of int: cost = [|
  0, 41, 42, 31, 39,  2, 18 |
  48, 0,  9, 22, 47, 29, 39 |
  36, 22, 0, 29, 45, 33, 45 |
  19, 5, 10, 0,  3, 42, 20 |
  13, 10, 21, 7,  0, 35, 11 |
  5,  35, 29, 16, 40, 0,  9 |
  7,  24, 26, 38, 33, 13, 0
|];

array[C] of int: deficit = [ max(0, demand[i] - supply[i]) | i in C ];
int: total_deficit = sum(i in C)(deficit[i]);
int: UB = total_deficit;

array[C, C] of var 0..UB: x;

constraint forall(i in C)(x[i,i] = 0);

constraint forall(i in C)(
  sum(j in C)(x[i,j]) <= max(0, supply[i] - demand[i])
);

constraint forall(j in C)(
  sum(i in C)(x[i,j]) >= deficit[j]
);

solve minimize sum(i in C, j in C)(cost[i,j] * x[i,j]);

output ["min_cost=" ++ show(sum(i in C, j in C)(cost[i,j] * x[i,j])) ++ "\n"];