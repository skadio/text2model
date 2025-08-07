include "globals.mzn";

% Parameters (to be provided in a .dzn file)
int: r;
int: c;
float: Z;
float: M;

% Decision variables: a grid of floats in [Z, M]
array[1..r, 1..c] of var Z..M: grid;

% For interior cells (i.e. not on the boundary) the five‐point finite-difference
% (Dirichlet) condition is applied:
%
%   grid[i,j] = (grid[i-1,j] + grid[i+1,j] + grid[i,j-1] + grid[i,j+1]) / 4
%
% Note: For grids smaller than 3x3 the domain of interior indices is empty and 
%       no such constraints are imposed.
constraint forall(i in 2..r-1, j in 2..c-1) (
    grid[i,j] = (grid[i-1,j] + grid[i+1,j] + grid[i,j-1] + grid[i,j+1]) / 4.0
);

% Objective: minimize the value at the top-left cell (position (1,1))
solve minimize grid[1,1];

% Output the computed grid
output [
  "Grid:\n" 
] ++ 
[
  concat([ show(grid[i,j]) ++ if j = c then "\n" else " " endif | j in 1..c ])
  | i in 1..r
];