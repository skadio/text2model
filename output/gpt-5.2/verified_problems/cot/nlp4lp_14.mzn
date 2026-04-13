% Parameters
int: M;
int: N;

array[1..M, 1..N] of float: A;
array[1..M] of float: B;

% Variables
array[1..N] of var float: y;
var float: r;

% Constraints
constraint r >= 0.0;

% Each halfspace constraint must contain the entire ball:
% a_i^T y + ||a_i||_2 * r <= b_i
constraint
  forall(i in 1..M) (
    sum(j in 1..N)(A[i,j] * y[j]) + sqrt(sum(j in 1..N)(A[i,j] * A[i,j])) * r <= B[i]
  );

% Objective
solve maximize r;