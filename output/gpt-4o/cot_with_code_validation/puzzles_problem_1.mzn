% Parameters
int: n;
int: m;

set of int: Rows = 1..n;
set of int: Cols = 1..m;

array[Rows, Cols] of int: grid;

% Variables
array[Rows] of var Cols: path;   % path[r] = chosen column in row r

% Constraints
constraint
  forall(r in 1..n-1)(
    abs(path[r+1] - path[r]) <= 1
  );

% Objective
solve maximize
  sum(r in Rows)(grid[r, path[r]]);