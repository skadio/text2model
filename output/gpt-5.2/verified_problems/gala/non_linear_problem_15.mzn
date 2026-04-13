% Laplace / Dirichlet problem on an r x c grid using the 5-point stencil
% (each cell equals the average of its N,S,E,W neighbors)
%
% Data provided in .dzn:
%   int: r; int: c; float: Z; float: M;

include "globals.mzn";

int: r;
int: c;
float: Z;
float: M;

set of int: R = 1..r;
set of int: C = 1..c;

% Grid values
array[R, C] of var float: x;

% Bounds
constraint forall(i in R, j in C)( Z <= x[i,j] /\ x[i,j] <= M );

% 5-point finite difference (Leibman) equation for interior points
constraint
  forall(i in 2..r-1, j in 2..c-1) (
    4.0 * x[i,j] = x[i-1,j] + x[i+1,j] + x[i,j-1] + x[i,j+1]
  );

% Objective: minimize value at (1,1)
solve minimize x[1,1];

output [
  "x[1,1] = ", show(x[1,1]), "\n",
  "Grid x =\n",
  concat([ concat([ show(x[i,j]) ++ if j=c then "\n" else " " endif | j in C ]) | i in R ])
];