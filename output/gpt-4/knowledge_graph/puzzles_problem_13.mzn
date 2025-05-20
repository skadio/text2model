include "globals.mzn";

% Parameters
int: r; % Number of rows
int: c; % Number of columns
array[1..r, 1..c] of int: puzzle; % Hidato puzzle grid

% Variables
array[1..r, 1..c] of var 1..r*c: grid; % Grid to be filled

% Constraints
% The filled cells in the puzzle should match with the grid
constraint forall(i in 1..r, j in 1..c)(puzzle[i,j] > 0 -> grid[i,j] = puzzle[i,j]);

% Each number from 1 to r*c should appear exactly once in the grid
constraint alldifferent(flatten(grid));

% Each number in the grid should be adjacent to the next number
constraint forall(i in 1..r, j in 1..c, di in -1..1, dj in -1..1)
    ((i+di > 0 /\ i+di <= r /\ j+dj > 0 /\ j+dj <= c) -> 
    (grid[i,j] + 1 = grid[i+di,j+dj] \/ grid[i,j] - 1 = grid[i+di,j+dj]));

% Solve
solve satisfy;