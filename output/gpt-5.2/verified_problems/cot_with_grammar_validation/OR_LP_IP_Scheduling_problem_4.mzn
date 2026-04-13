int: n;
array[1..n, 1..n] of int: huts;

set of int: R = 1..n;
set of int: C = 1..n;

array[1..2] of var R: drop_r;
array[1..2] of var C: drop_c;

constraint all_different([ (drop_r[k] - 1) * n + drop_c[k] | k in 1..2 ]);

var int: total_cost =
  sum(r in R, c in C where huts[r, c] != 0) (
    min([ (r - drop_r[k]) * (r - drop_r[k]) + (c - drop_c[k]) * (c - drop_c[k]) | k in 1..2 ])
  );

solve minimize total_cost;