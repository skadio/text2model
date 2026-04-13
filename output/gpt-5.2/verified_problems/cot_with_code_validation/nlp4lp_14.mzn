% Chebyshev center of a polyhedron: maximize inscribed ball radius

% Parameters
int: M;
int: N;
array[1..M, 1..N] of float: A;
array[1..M] of float: B;

% Precompute row norms of A (constants)
array[1..M] of float: Anorm = [ sqrt(sum(j in 1..N)(A[i,j] * A[i,j])) | i in 1..M ];

% Variables
array[1..N] of var float: y;
var float: r;

% Constraints
constraint r >= 0.0;

constraint
  forall(i in 1..M)(
    sum(j in 1..N)(A[i,j] * y[j]) + r * Anorm[i] <= B[i]
  );

% Objective
solve maximize r;