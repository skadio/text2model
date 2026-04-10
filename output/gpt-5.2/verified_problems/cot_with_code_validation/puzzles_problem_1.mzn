% Parameters
int: n;
int: m;
array[1..n, 1..m] of int: grid;

% Variables
array[1..n] of var 1..m: col;     % chosen column in each row
var int: total;

% Constraints: move down, down-left, or down-right between consecutive rows
constraint forall(r in 2..n) (
  abs(col[r] - col[r-1]) <= 1
);

% Total sum along the chosen path
constraint total = sum(r in 1..n)( grid[r, col[r]] );

% Objective
solve maximize total;

output [
  "total = ", show(total), "\n",
  "col = ", show(col), "\n"
];