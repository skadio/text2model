include "globals.mzn";

% Parameters
int: n; % Number of rows in the grid
int: m; % Number of columns in the grid
array[1..n, 1..m] of int: grid; % Square grid of numbers

% Decision variables
array[1..n] of var 1..m: path; % Path taken
var int: max_sum; % Maximum sum

% Constraints
constraint forall(i in 2..n) (
  path[i] = path[i-1] \/ path[i] = path[i-1] + 1 \/ path[i] = path[i-1] - 1
);

% Objective
constraint max_sum = sum(i in 1..n) (grid[i, path[i]]);

% Solve
solve maximize max_sum;

% Output
output [ "Max sum: " ++ show(max_sum) ++ "\n" ] ++
[ if fix(path[i]) = j then "X " else "  " endif | i in 1..n, j in 1..m ] ++
[ "\n" | i in 1..n ];