include "globals.mzn";

% Input data
int: n;                      % number of rows
int: m;                      % number of columns
array[1..n, 1..m] of int: grid;

% Decision variables:
% col[r] = chosen column in row r (1..m)
array[1..n] of var 1..m: col;

% Move constraints: from row r to r+1 you may go down-left, down, down-right
constraint forall(r in 1..n-1) (
    abs(col[r+1] - col[r]) <= 1
);

% Objective: maximize sum of chosen cells
var int: total = sum(r in 1..n)( grid[r, col[r]] );

solve maximize total;

output [
  "max_sum = ", show(total), "\n",
  "path_cols_1based = ", show(col), "\n",
  "picked_values = ", show([ grid[r, fix(col[r])] | r in 1..n ]), "\n"
];