% Chebyshev center of a polyhedron:
%   Maximize r
%   s.t. a_i^T y + r * ||a_i||_2 <= b_i,  i=1..M
%
% Data provided in .dzn:
%   int: M;
%   int: N;
%   array[1..M, 1..N] of float: A;
%   array[1..M] of float: B;

include "globals.mzn";

int: M;
int: N;
array[1..M, 1..N] of float: A;
array[1..M] of float: B;

set of int: I = 1..M;
set of int: J = 1..N;

% Precompute Euclidean norms of each constraint normal a_i
array[I] of float: anorm = [
  sqrt( sum(j in J)( A[i,j] * A[i,j] ) )
| i in I
];

% Decision variables: center y and radius r
array[J] of var float: y;
var float: r;

% Radius must be nonnegative
constraint r >= 0.0;

% Containment constraints for the largest inscribed ball
constraint forall(i in I)(
  sum(j in J)( A[i,j] * y[j] ) + r * anorm[i] <= B[i]
);

solve maximize r;

output [
  "r = ", show(r), "\n",
  "y = ", show(y), "\n"
];