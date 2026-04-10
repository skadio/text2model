int: N = 5;
set of int: REGIONS = 1..N;

array[REGIONS] of int: stock = [410, 266, 132, 6, 485];
array[REGIONS] of int: need  = [274, 331, 232, 359, 74];

array[REGIONS, REGIONS] of int: cost =
  array2d(REGIONS, REGIONS,
  [
    0, 24,  3, 27, 31,
   24,  0, 11,  7, 37,
   30,  1,  0, 38, 22,
   36, 18, 17,  0, 35,
   41, 35, 33, 33,  0
  ]);

int: MAXSHIP = sum(stock);
array[REGIONS, REGIONS] of var 0..MAXSHIP: x;

var int: total_cost = sum(i in REGIONS, j in REGIONS)(cost[i,j] * x[i,j]);

constraint forall(i in REGIONS)(x[i,i] = 0);

constraint forall(i in REGIONS)(
  sum(j in REGIONS)(x[i,j]) <= stock[i]
);

constraint forall(j in REGIONS)(
  stock[j] - sum(k in REGIONS)(x[j,k]) + sum(i in REGIONS)(x[i,j]) = need[j]
);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "x =\n",
  concat([ concat([ (if j = 1 then "" else " " endif) ++ show(x[i,j]) | j in REGIONS ]) ++ "\n"
         | i in REGIONS ])
];