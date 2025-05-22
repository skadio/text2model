% Parameters
int: r; % Number of rows in the Laplace grid
int: c; % Number of columns in the Laplace grid
float: Z; % Zero value (constant)
float: M; % Maximum value (constant)

% Variables
array[1..r, 1..c] of var float: grid; % Values of cells in the grid

% Constraints
constraint forall(i in 2..r-1, j in 2..c-1) (
  grid[i,j] = (grid[i-1,j] + grid[i+1,j] + grid[i,j-1] + grid[i,j+1]) / 4.0
);

% Boundary conditions
constraint forall(i in 1..r) (
  grid[i,1] = Z /\ grid[i,c] = Z
);
constraint forall(j in 1..c) (
  grid[1,j] = Z /\ grid[r,j] = Z
);

% Objective
solve minimize grid[1,1];