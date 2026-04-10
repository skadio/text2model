int: n;
array[1..n, 1..n] of int: huts;

set of int: R = 1..n;
set of int: C = 1..n;

array[R, C] of int: demand = huts;

int: K = 2;

array[1..K] of var R: drop_r;
array[1..K] of var C: drop_c;

constraint
  forall(k1 in 1..K, k2 in k1+1..K) (
    drop_r[k1] != drop_r[k2] \/ drop_c[k1] != drop_c[k2]
  );

function var int: sqdist(var int: r1, var int: c1, int: r2, int: c2) =
  (r1 - r2) * (r1 - r2) + (c1 - c2) * (c1 - c2);

array[R, C] of var int: mindist;

constraint
  forall(i in R, j in C) (
    mindist[i,j] = min([ sqdist(drop_r[k], drop_c[k], i, j) | k in 1..K ])
  );

var int: obj =
  sum(i in R, j in C) ( demand[i,j] * mindist[i,j] );

solve minimize obj;

output [
  "drop_locations = [",
  concat([ if k > 1 then ", " else "" endif ++ "(" ++ show(drop_r[k]) ++ "," ++ show(drop_c[k]) ++ ")" | k in 1..K ]),
  "]\n",
  "objective = ", show(obj), "\n"
];