% Parameters
int: n; % Number of rows in the grid
int: m; % Number of columns in the grid
array[1..n, 1..m] of int: grid; % Square grid of numbers

% Variables
array[1..n] of var 1..m: path; % The path taken to achieve the maximum sum
var int: max_sum; % The maximum sum achievable

% Constraints

% The maximum sum is the sum of the elements in the grid at the positions specified by the path
constraint max_sum = sum(i in 1..n)(grid[i, path[i]]);

% The path can only move straight down, down to the right, or down to the left
constraint forall(i in 2..n)(
    path[i] >= path[i-1] - 1 /\ path[i] <= path[i-1] + 1
);

% Objective
solve maximize max_sum;