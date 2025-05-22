% Parameters
int: M;
int: N;
array[1..M, 1..N] of float: A;
array[1..M] of float: B;

% Pre-computed constants
array[1..M] of float: normA =
  [ sqrt(sum(j in 1..N)(A[i, j] * A[i, j])) | i in 1..M ];

% Generic upper bound for variables (can be tightened if desired)
float: BIG = 1.0e6;

% Decision variables
array[1..N] of var -BIG..BIG: y;   % Chebychev centre
var 0.0..BIG: r;                   % Radius of the inscribed ball

% Constraints
constraint
  forall(i in 1..M)(
    sum(j in 1..N)(A[i, j] * y[j]) + normA[i] * r <= B[i]
  );

% Objective
solve maximize r;