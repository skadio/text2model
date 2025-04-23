% Parameters
int: n; % Number of rows in the grid
int: m; % Number of columns in the grid
array[1..n, 1..m] of int: grid; % Square grid of numbers

% Variables
array[1..n] of var 1..m: path; % The path taken to achieve the maximum sum
var int: max_sum; % The maximum sum achievable

% Constraints

% The first element of the path should be within the grid
constraint path[1] >= 1 /\ path[1] <= m;

% The path from one row to the next can be either straight down, down to the right, or down to the left
constraint forall(i in 2..n) (
    path[i] >= max(1, path[i-1] - 1) /\ path[i] <= min(m, path[i-1] + 1)
);

% The maximum sum is the sum of the elements in the grid at the indices specified by the path
constraint max_sum = sum(i in 1..n)(grid[i, path[i]]);

% Objective
solve maximize max_sum;