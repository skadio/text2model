% Parameters
int: r;
int: c;
float: Z;
float: M;

% Variables
var float: grid[1..r, 1..c];

% Constraints
constraint
  forall(i in 1..r, j in 1..c) (
    Z <= grid[i,j] /\ grid[i,j] <= M
  );

constraint
  forall(i in 2..r-1, j in 2..c-1) (
    grid[i,j] = (grid[i-1,j] + grid[i+1,j] + grid[i,j-1] + grid[i,j+1]) / 4.0
  );

% Objective
solve minimize grid[1,1];