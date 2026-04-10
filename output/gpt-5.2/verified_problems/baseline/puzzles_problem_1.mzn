int: n;
int: m;
array[1..n, 1..m] of int: grid;

set of int: ROWS = 1..n;
set of int: COLS = 1..m;

array[ROWS] of var COLS: path;
var int: max_sum;

constraint
  forall(r in 2..n) (
    abs(path[r] - path[r-1]) <= 1
  );

constraint
  max_sum = sum(r in ROWS)( grid[r, path[r]] );

solve maximize max_sum;

output [
  "max_sum = ", show(max_sum), ";\n",
  "path = ", show([path[r] | r in ROWS]), ";\n"
];