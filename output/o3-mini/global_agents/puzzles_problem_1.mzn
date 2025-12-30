include "globals.mzn";

% Input parameters (provided in a .dzn file)
int: n; % number of rows in the grid
int: m; % number of columns in the grid
array[1..n, 1..m] of int: grid;

% Decision variable: for each row, choose a column (1..m)
array[1..n] of var 1..m: path;

% Constraint: The movement between consecutive rows must be either 
% straight down, down-left, or down-right.
constraint
  forall(i in 2..n) (
    abs(path[i] - path[i-1]) <= 1
  );

% Define the total sum for the chosen path:
var int: total = sum(i in 1..n)( grid[i, path[i]] );

% Solve: maximize the total sum
solve maximize total;

% Output: the selected path (column indices for each row) and the maximum sum
output [
  "Path: ", show(path), "\n",
  "Max Sum: ", show(total), "\n"
];