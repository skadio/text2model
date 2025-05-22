% Parameters
int: M; % The number of inequalities defining the set P
int: N; % The ambient space dimension of the set P
array[1..M, 1..N] of float: A; % The coefficients of the linear inequalities defining the set P
array[1..M] of float: B; % The right-hand side of the inequalities defining the set P

% Variables
var 0.0..max(B): r; % The radius of the ball
array[1..N] of var float: y; % The center of the ball

% Constraints
constraint forall(i in 1..M) (
  sum(j in 1..N) (A[i,j]*y[j]) + r*sqrt(sum(j in 1..N) (A[i,j]*A[i,j])) <= B[i]
);

% Objective
solve maximize r;