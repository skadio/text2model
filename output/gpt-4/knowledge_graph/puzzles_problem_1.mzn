include "globals.mzn";

% Parameters
int: n; % Number of rows in the grid
int: m; % Number of columns in the grid
array[1..n, 1..m] of int: grid; % Square grid of numbers

% Variables
array[1..n] of var 1..m: path; % Path taken through the grid

% Constraints
constraint forall(i in 2..n) (
  path[i] = path[i-1] \/ path[i] = path[i-1] + 1 \/ path[i] = path[i-1] - 1
);

% Objective
var int: total = sum(i in 1..n)(grid[i, path[i]]);
solve maximize total;

% Output
output [ "Path: " ++ show(path) ++ "\n" ++ "Total: " ++ show(total) ];