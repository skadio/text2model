int: n;
int: m;

array[1..n, 1..m] of int: grid;

array[1..n] of var 1..m: path;

constraint
  forall(r in 2..n) (
    abs(path[r] - path[r-1]) <= 1
  );

var int: maxSum = sum(r in 1..n)( grid[r, path[r]] );

solve maximize maxSum;

output [
  "maxSum = ", show(maxSum), "\n",
  "path = ", show(path), "\n"
];