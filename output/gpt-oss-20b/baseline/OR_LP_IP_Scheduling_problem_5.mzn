int: rows;
int: cols;
array[1..rows, 1..cols] of int: cost;

var bool: x[1..rows, 1..cols];

constraint
  forall(i in 1..rows) (
    sum(j in 1..cols) (x[i,j]) = 1
  );

constraint
  forall(j in 1..cols) (
    sum(i in 1..rows) (x[i,j]) = 1
  );

solve minimize
  sum(i in 1..rows, j in 1..cols) (cost[i,j] * bool2int(x[i,j]));

output [
  "x = ", show(x), "\n"
];