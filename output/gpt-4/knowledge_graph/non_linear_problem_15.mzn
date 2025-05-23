% Parameters
int: r; % Number of rows
int: c; % Number of columns
float: Z; % Zero value
float: M; % Maximum value

% Variables
array[1..r, 1..c] of var Z..M: grid;

% Constraints
constraint forall(i in 2..r-1, j in 2..c-1) (
    grid[i,j] = (grid[i-1,j] + grid[i+1,j] + grid[i,j-1] + grid[i,j+1]) / 4.0
);

% Objective
solve minimize grid[1,1];