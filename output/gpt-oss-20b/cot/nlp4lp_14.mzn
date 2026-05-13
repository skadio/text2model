% Parameters
int: M;
int: N;
array[1..M, 1..N] of float: A;
array[1..M] of float: B;

% Variables
array[1..N] of var float: x;
var float: r;

% Constraints
constraint r >= 0;
constraint forall(i in 1..M) (
    sum(j in 1..N)(A[i,j] * x[j]) + r * sqrt(sum(j in 1..N)(A[i,j] * A[i,j])) <= B[i]
);

% Objective
solve maximize r;