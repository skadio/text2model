include "globals.mzn";

int: rows;
int: cols;

array[1..rows, 1..cols] of int: cost;

array[1..rows, 1..cols] of var 0..1: x;

constraint forall(i in 1..rows) (
  sum(j in 1..cols)(x[i,j]) = 1
);

constraint forall(j in 1..cols) (
  sum(i in 1..rows)(x[i,j]) = 1
);

var int: total_preference = sum(i in 1..rows, j in 1..cols)(cost[i,j] * x[i,j]);

solve minimize total_preference;

output [
  "total_preference=", show(total_preference), "\n",
  "x=\n"
] ++
[
  concat([show(x[i,j]) ++ if j = cols then "\n" else " " endif | j in 1..cols])
  | i in 1..rows
];