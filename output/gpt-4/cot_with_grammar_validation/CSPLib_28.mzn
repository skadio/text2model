% Parameters
int: v; % Number of distinct objects
int: k; % Number of distinct objects in each block
int: lambda; % Scalar product between any pair of distinct rows

% Variables
array[1..v, 1..v] of var 0..1: x; % Binary matrix where x[i,j] = 1 if object i is in block j

% Constraints
% Each object appears in a fixed number of blocks
constraint forall(i in 1..v)(sum(j in 1..v)(x[i,j]) = k);

% Each block contains a fixed number of objects
constraint forall(j in 1..v)(sum(i in 1..v)(x[i,j]) = k);

% Every pair of objects appears together in a fixed number of blocks
constraint forall(i in 1..v, j in i+1..v)(sum(k in 1..v)(x[i,k] * x[j,k]) = lambda);

% Objective
% As this is a feasibility problem, we do not have an objective to optimize.
solve satisfy;