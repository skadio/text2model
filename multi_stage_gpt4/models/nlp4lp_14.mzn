% Parameters
int: M; % The number of inequalities defining the set P
int: N; % The ambient space dimension of the set P
array[1..M, 1..N] of float: A; % The coefficients of the linear inequalities defining the set P
array[1..M] of float: B; % The right-hand side of the inequalities defining the set P

% Variables
var float: r; % The radius of the ball
array[1..N] of var float: y; % The center of the ball

% Constraints

% The ball with center y and radius r is entirely contained within the set P
% This is ensured by the constraint {a_i}^T y + r * ||a_i|| <= b_i for all i = 1, ..., M
% where ||a_i|| is the Euclidean norm of a_i
constraint forall(i in 1..M) (
    sum(j in 1..N) (A[i,j] * y[j]) + r * sqrt(sum(j in 1..N) (A[i,j]^2)) <= B[i]
);

% Objective

% We want to find a ball with the largest possible radius, which is entirely contained within the set P
% This is a maximization problem
solve maximize r;