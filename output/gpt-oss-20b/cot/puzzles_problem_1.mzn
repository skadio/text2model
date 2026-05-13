% Parameters
int: n;
int: m;
array[1..n, 1..m] of int: grid;

% Variables
array[1..n] of var 1..m: path;

% Constraints
constraint forall(i in 2..n)(abs(path[i] - path[i-1]) <= 1);

% Objective
solve maximize sum(i in 1..n)(element(grid[i, 1..m], path[i]));