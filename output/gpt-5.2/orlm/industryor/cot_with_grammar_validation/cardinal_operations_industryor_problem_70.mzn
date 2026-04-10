include "globals.mzn";

int: n = 2;
set of int: F = 1..n;
set of int: L = 1..n;

array[F, F] of int: d = array2d(F, F, [
  10, 20,
  30, 40
]);

array[L, L] of int: c = array2d(L, L, [
  5, 8,
  6, 7
]);

array[F] of var L: loc;

constraint alldifferent(loc);

var int: total_cost = sum(i in F, j in F) (d[i, j] * c[loc[i], loc[j]]);

solve minimize total_cost;

output [
  "loc = ", show(loc), "\n",
  "total_cost = ", show(total_cost), "\n"
];