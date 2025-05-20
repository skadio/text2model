% Parameters
int: v; % Number of distinct objects
int: k; % Number of distinct objects in each block
int: lambda; % Scalar product between any pair of distinct rows

% Variables
array[1..v, 1..v] of var 0..1: X; % Binary matrix representing the blocks

% Constraints
% Each object appears in a fixed number of blocks
constraint forall(i in 1..v)(sum(j in 1..v)(X[i,j]) = k);

% Every pair of objects appears together in a fixed number of blocks
constraint forall(i in 1..v, j in i+1..v)(sum(k in 1..v)(X[i,k]*X[j,k]) = lambda);

% The number of blocks is equal to the number of objects times the number of occurrences of each object in blocks divided by the number of distinct objects in each block
constraint sum(i in 1..v, j in 1..v)(X[i,j]) = v*k;

% Solve
solve satisfy;