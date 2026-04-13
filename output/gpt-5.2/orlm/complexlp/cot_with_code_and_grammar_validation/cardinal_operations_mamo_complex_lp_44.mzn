int: N = 7;
set of int: R = 1..N;

array[R] of int: supply = [318, 349, 129, 381, 430, 52, 124];
array[R] of int: demand = [309, 9, 279, 71, 365, 233, 483];

array[R, R] of int: cost =
  [|  0,  2, 26, 19, 16, 26, 36
   | 27,  0, 26,  4, 15, 43, 25
   | 17, 45,  0, 18, 36, 37, 39
   | 19, 16, 14,  0,  5, 35,  9
   | 44, 47,  4,  3,  0,  2,  4
   | 30, 12, 28, 10, 16,  0, 25
   | 19, 16, 10,  2, 50,  4,  0
  |];

int: totalSupply = sum(r in R)(supply[r]);
int: totalDemand = sum(r in R)(demand[r]);

int: M = if totalSupply > totalDemand then N + 1 else N endif;
set of int: D = 1..M;

array[D] of int: demand2 =
  if totalSupply > totalDemand then
    [demand[1], demand[2], demand[3], demand[4], demand[5], demand[6], demand[7], totalSupply - totalDemand]
  else
    [demand[1], demand[2], demand[3], demand[4], demand[5], demand[6], demand[7]]
  endif;

array[R, D] of int: cost2 =
  if totalSupply > totalDemand then
    array2d(R, D,
      [cost[i,j] | i in R, j in R] ++ [0 | i in R]
    )
  else
    array2d(R, D, [cost[i,j] | i in R, j in D])
  endif;

array[R, D] of var 0..totalSupply: x;

constraint forall(i in R)(
  if i in D then x[i,i] = 0 else true endif
);

constraint forall(i in R)(
  sum(j in D)(x[i,j]) = supply[i]
);

constraint forall(j in D)(
  sum(i in R)(x[i,j]) = demand2[j]
);

solve minimize sum(i in R, j in D)(cost2[i,j] * x[i,j]);

output [
  "min_cost=", show(sum(i in R, j in D)(cost2[i,j] * x[i,j])), "\n"
];