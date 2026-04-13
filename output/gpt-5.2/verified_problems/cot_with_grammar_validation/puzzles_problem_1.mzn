% Parameters
int: n;
int: m;
array[1..n, 1..m] of int: grid;

% Variables
array[1..n] of var 1..m: col;          % chosen column in each row
var int: total;

% Constraints
constraint forall(i in 2..n) (
  abs(col[i] - col[i-1]) <= 1
);

constraint total = sum(i in 1..n) ( grid[i, col[i]] );

% Objective
solve maximize total;