% Parameters
int: n;
int: m;
array[1..n, 1..m] of int: grid;

% Variables
array[1..n] of var 1..m: col;
var int: total;

% Constraints
constraint forall(r in 2..n)(
  abs(col[r] - col[r-1]) <= 1
);

constraint total = sum(r in 1..n)( grid[r, col[r]] );

% Objective
solve maximize total;